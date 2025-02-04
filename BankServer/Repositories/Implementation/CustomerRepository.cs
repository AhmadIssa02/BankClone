using AutoMapper;
using BankServer.Models;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using BankServer.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Text.RegularExpressions;

namespace BankServer.Repositories.Implementation
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly ApiDbContext _context;
        private readonly IMapper _mapper;
        public CustomerRepository(ApiDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<bool> addCustomer(CustomerDto customerdto)
        {
            if (!IsValidEmail(customerdto.Email))
            {
                return false;
            }

            var customer = _mapper.Map<Customer>(customerdto);

            var accountNumber = GenerateRandomAccountNumber();
            customer.AccountNumber = accountNumber;  
            customer.IBAN = GenerateRandomIBAN(accountNumber);  

            await _context.Customers.AddAsync(customer);
            await _context.SaveChangesAsync();

            return true;
        }
        public async Task<bool> deleteCustomer(string email)
        {
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == email);
                if (customer == null)
                {
                    return false;
                }

                _context.Customers.Remove(customer);
                await _context.SaveChangesAsync();
                return true;
            }
        }

        public async Task<bool> editCustomer(CustomerDto customerdto)
        {
            var existingCustomer = await _context.Customers
                                                  .FirstOrDefaultAsync(c => c.Email == customerdto.Email);

            if (existingCustomer == null)
            {
                return false;
            }

            existingCustomer.PasswordHash = customerdto.Password;

            await _context.SaveChangesAsync();

            return true;
        }


        public async Task<IList<Customer>> getAllCutsomers()
        {
            return await _context.Customers.ToListAsync();
        }

        public async Task<Customer> getCustomerByEmail(string email)
        {
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == email);
            return customer;
        }

        private string GenerateRandomIBAN(int accountNumber)
        {
            var random = new Random();

            // Generate random IBAN in the format: JOXXEFBKXXXXXXXX
            var iban = "JO" + random.Next(10, 99).ToString() + "EFBK" + random.Next(100000000, 999999999).ToString();

            iban += accountNumber.ToString();  

            return iban;
        }

        private int GenerateRandomAccountNumber()
        {
            var random = new Random();
            return random.Next(100000000, 999999999);  
        }

        private bool IsValidEmail(string email)
        {
            var emailRegex = new Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            return emailRegex.IsMatch(email);
        }
    }
}
