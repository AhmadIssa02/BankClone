using BankServer.Models.Domain;
using BankServer.Models.DTOs;

public interface ICustomerService
{
    Task<bool> AddCustomerAsync(RegisterCustomerDto customerDto);
    Task<bool> EditCustomerAsync(RegisterCustomerDto customerDto);
    Task<bool> DeleteCustomerAsync(string email);
    Task<IList<Customer>> GetAllCustomersAsync();
    Task<Customer> GetCustomerByEmailAsync(string email);
    Task<bool> ChangePasswordAsync(EditCustomerPasswordDto editCustomerDto);
}