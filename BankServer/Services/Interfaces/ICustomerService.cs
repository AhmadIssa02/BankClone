using BankServer.Models.Domain;
using BankServer.Models.DTOs;

public interface ICustomerService
{
    Task<bool> AddCustomerAsync(CustomerDto customerDto);
    Task<bool> EditCustomerAsync(CustomerDto customerDto);
    Task<bool> DeleteCustomerAsync(string email);
    Task<IList<Customer>> GetAllCustomersAsync();
    Task<Customer> GetCustomerByEmailAsync(string email);
}