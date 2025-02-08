using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using BankServer.Models;
using BankServer.Models.DTOs;
using BankServer.Repositories.Interfaces;
using System.Threading.Tasks;
using BankServer.Models.Domain;
using Microsoft.EntityFrameworkCore;
using BankServer.Models.Domain.BankServer.Models.Domain;

namespace BankServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountBalanceController : ControllerBase
    {
        private readonly UserManager<Customer> _userManager;
        private readonly IUnitOfWork _unitOfWork;

        public AccountBalanceController(
            UserManager<Customer> userManager,
            IUnitOfWork unitOfWork)
        {
            _userManager = userManager;
            _unitOfWork = unitOfWork;
        }

        [HttpPost]
        public async Task<IActionResult> CreateAccountBalance([FromBody] AccountBalanceDto accountBalanceDTO)
        {
            if (accountBalanceDTO == null)
            {
                return BadRequest("Invalid account balance data");
            }

            var customer = await _userManager.FindByIdAsync(accountBalanceDTO.CustomerId);
            if (customer == null)
            {
                return NotFound("Customer not found");
            }
            var existingAccountBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.CustomerId == customer.Id);
            if (existingAccountBalance != null)
            {
                return BadRequest("Account balance already exists for this customer");
            }

            var accountBalance = new AccountBalance
            {
                CustomerId = customer.Id,
                Balance = accountBalanceDTO.Balance,
            };

            await _unitOfWork.AccountBalanceRepository.Insert(accountBalance);
            await _unitOfWork.Save();

            return Ok(accountBalance);
        }
        [HttpPut]
        public async Task<IActionResult> UpdateAccountBalance([FromBody] AccountBalanceDto accountBalanceDto)
        {
            var accountBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.CustomerId == accountBalanceDto.CustomerId);

            if (accountBalance == null)
            {
                return NotFound("Account balance not found");
            }

            accountBalance.Balance = accountBalanceDto.Balance;

            _unitOfWork.AccountBalanceRepository.Update(accountBalance);
            await _unitOfWork.Save();

            return Ok(accountBalance);
        }

        [HttpGet("{accountNumber}")]
        public async Task<IActionResult> GetAccountBalance(int accountNumber)
        {
            var accountBalance = await _unitOfWork.AccountBalanceRepository.Get(a => a.AccountBalanceId == accountNumber);
            if (accountBalance == null)
            {
                return NotFound("Account balance not found");
            }
            return Ok(accountBalance);
        }
    }
}
