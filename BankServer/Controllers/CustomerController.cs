using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using BankServer.Services.Implementations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BankServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomerService _customerService;

        public CustomerController(ICustomerService customerService)
        {
            _customerService = customerService;
        }

        [HttpGet("{email}")]
        public async Task<IActionResult> GetCustomerByEmail(string email)
        {
            var result = await _customerService.GetCustomerByEmailAsync(email);
            return Ok(result);
        }
        [HttpGet("getAll")]
        public async Task<IActionResult> GetCustomers()
        {
            var customers = await _customerService.GetAllCustomersAsync();
            return Ok(customers);
        }

        [HttpPost]
        public async Task<IActionResult> AddCustomer(RegisterCustomerDto customerDto)
        {
            if (!IsValidEmail(customerDto.Email))
            {
                return BadRequest("Invalid Email");
            }

            var result = await _customerService.AddCustomerAsync(customerDto);
            if(result == false)
            {
                return BadRequest("Email already Exists");
            }
            return Ok(result);
        }

        [HttpPut]
        public async Task<IActionResult> EditCustomer(RegisterCustomerDto customerDto)
        {
            var result = await _customerService.EditCustomerAsync(customerDto);
            return Ok(result);
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteCustomer(string email)
        {
            var result = await _customerService.DeleteCustomerAsync(email);
            return Ok(result);
        }
        [HttpPut("changePassword")]
        public async Task<IActionResult> ChangePassword(EditCustomerPasswordDto editCustomerDto)
        {
            var result = await _customerService.ChangePasswordAsync(editCustomerDto);
            return Ok(result);
        }
        private bool IsValidEmail(string email)
        {
            var emailRegex = new System.Text.RegularExpressions.Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            return emailRegex.IsMatch(email);
        }
    }
}
