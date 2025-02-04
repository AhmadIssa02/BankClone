using BankServer.Models;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using BankServer.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace BankServer.Repositories.Implementation
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly ApiDbContext _context;

        public CustomerRepository(ApiDbContext context)
        {
            _context = context;
        }

        public async Task<bool> addCustomer(Customer customer)
        {
            var existingCustomer = await _context.Customers.FirstOrDefaultAsync(c => c.Email == customer.Email); 

            if (existingCustomer != null)
            {
                return false; 
            }
            await _context.Customers.AddAsync(customer);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> deleteCustomer(string email)
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

        public async Task<bool> editCustomer(Customer customer)
        {
            var existingCustomer = await _context.Customers
                                                  .FirstOrDefaultAsync(c => c.Email == customer.Email);

            if (existingCustomer == null)
            {
                return false;
            }

            existingCustomer.PasswordHash = customer.PasswordHash;
            existingCustomer.FirstName = customer.FirstName;
            existingCustomer.LastName = customer.LastName;

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

        public async Task<bool> changePassword(Customer customer)
        {
            var existingCustomer = await _context.Customers
                                                  .FirstOrDefaultAsync(c => c.Email == customer.Email);

            if (existingCustomer == null)
            {
                return false;
            }

            existingCustomer.PasswordHash = customer.PasswordHash;

            await _context.SaveChangesAsync();

            return true;
        }

      
    }
}
