using Microsoft.AspNetCore.Mvc;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using Microsoft.AspNetCore.Identity;
using BankServer.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using BankServer.Models.Domain.BankServer.Models.Domain;

namespace BankServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransactionController : ControllerBase
    {
        private readonly UserManager<Customer> _userManager;
        private readonly IUnitOfWork _unitOfWork;
        private readonly AccountBalanceController _accountBalanceController;

        public TransactionController(UserManager<Customer> userManager, IUnitOfWork unitOfWork, AccountBalanceController accountBalanceController)
        {
            _userManager = userManager;
            _unitOfWork = unitOfWork;
            _accountBalanceController = accountBalanceController;
        }

        [HttpPost]
        [Route("transfer")]
        public async Task<IActionResult> TransferMoney([FromBody] TransactionDto transactionDto)
        {
            // Find sender by account number
            var sender = await _userManager.Users
                .FirstOrDefaultAsync(u => u.AccountNumber == transactionDto.SenderAccountNumber);

            if (sender == null)
                return NotFound("Sender not found");

            // Find receiver by account number
            var receiver = await _userManager.Users
                .FirstOrDefaultAsync(u => u.AccountNumber == transactionDto.ReceiverAccountNumber);

            if (receiver == null)
                return NotFound("Receiver not found");

            // Find sender's AccountBalance using CustomerId
            var senderBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.CustomerId == sender.Id);
            if (senderBalance == null)
                return NotFound("Sender's account balance not found");

            // Find receiver's AccountBalance using CustomerId
            var receiverBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.CustomerId == receiver.Id);
            if (receiverBalance == null)
                return NotFound("Receiver's account balance not found");

            if (senderBalance.Balance < transactionDto.Amount)
                return BadRequest("Insufficient funds");

            var transaction = new Transaction
            {
                SenderCustomerId = sender.Id,
                ReceiverCustomerId = receiver.Id,
                Amount = transactionDto.Amount,
                TransactionDate = DateTime.UtcNow,
                Description = transactionDto.Description
            };

            senderBalance.Balance -= transactionDto.Amount;
            receiverBalance.Balance += transactionDto.Amount;

            // Save the transaction
            await _unitOfWork.TransactionRepository.Insert(transaction);

            // Update the sender and receiver balances using AccountBalanceDto
            var senderBalanceDto = new AccountBalanceDto { CustomerId = sender.Id, Balance = senderBalance.Balance };
            var receiverBalanceDto = new AccountBalanceDto { CustomerId = receiver.Id, Balance = receiverBalance.Balance };

            // Call the injected AccountBalanceController's UpdateAccountBalance method
            await _accountBalanceController.UpdateAccountBalance(senderBalanceDto);
            await _accountBalanceController.UpdateAccountBalance(receiverBalanceDto);

            await _unitOfWork.Save();

            return Ok(new
            {
                SenderNewBalance = senderBalance.Balance,
                ReceiverNewBalance = receiverBalance.Balance
            });
        }

        [HttpGet]
        [Route("history/{accountNumber}")]
        public async Task<IActionResult> GetTransactionHistory(int accountNumber)
        {
            var customer = await _userManager.Users
                .FirstOrDefaultAsync(u => u.AccountNumber == accountNumber);

            if (customer == null)
                return NotFound("Customer not found");

            var accountBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.CustomerId == customer.Id);

            if (accountBalance == null)
                return NotFound("Account balance not found");

            var transactions = await _unitOfWork.TransactionRepository.GetAll(t => t.SenderCustomerId == customer.Id || t.ReceiverCustomerId == customer.Id);

            return Ok(transactions);
        }
    }
}
