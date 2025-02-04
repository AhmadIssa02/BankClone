using BankServer.Models;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using BankServer.Repositories.Implementation;
using BankServer.Repositories.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BankServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : ControllerBase
    {
        private readonly ICustomerRepository _customerRepository;
        public CustomerController(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        [HttpGet("getAll")]
        public async Task<IActionResult> GetCustomers()
        {
            var customers = await _customerRepository.getAllCutsomers();
            return Ok(customers);
        }
        [HttpPost]
        public async Task<IActionResult> AddCustomer(CustomerDto customerdto)
        {
            return Ok(await _customerRepository.addCustomer(customerdto));

        }

        [HttpPut]
        public async Task<IActionResult> EditCustomer(CustomerDto customerdto)
        {

            var result = await _customerRepository.editCustomer(customerdto);

            return Ok(result);
        }
        [HttpDelete]
        public async Task<IActionResult> DeleteCustomer(string email)
        {
            var result = _customerRepository.deleteCustomer(email);
            return Ok(result);
        }
        [HttpGet("{email}")]
        public async Task<IActionResult> GetCustomerByEmail(string email)
        {
            var result = _customerRepository.getCustomerByEmail(email);
            return Ok(result);
        }
    }
}
