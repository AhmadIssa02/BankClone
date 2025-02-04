using BankServer.Models;
using BankServer.Models.DTOs;

namespace BankServer.Services.Interfaces
{
    public interface IAuthManager
    {
        Task<bool> ValidateUser(CustomerDto customerDto);
        Task<string> CreateToken();
        Task<string> CreateRefreshToken();
        Task<TokenRequest> VerifyRefreshToken(TokenRequest request);
    }
}
