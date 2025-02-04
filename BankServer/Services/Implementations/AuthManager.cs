using BankServer.Models;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using BankServer.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace BankServer.Services.Implementations
{
    public class AuthManager : IAuthManager
    {
        private readonly UserManager<Customer> _userManager;
        private readonly IConfiguration _configuration;
        private Customer _customer;
        private readonly ILogger<AuthManager> _logger;
        public AuthManager(UserManager<Customer> userManager,
            IConfiguration configuration,
            ILogger<AuthManager> logger)
        {
            _userManager = userManager;
            _configuration = configuration;
            _logger = logger;
        }

        public async Task<string> CreateToken()
        {
            var signingCredentials = GetSigningCredentials();
            var claims = await GetClaims();
            var token = GenerateTokenOptions(signingCredentials, claims);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        private JwtSecurityToken GenerateTokenOptions(SigningCredentials signingCredentials, List<Claim> claims)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var expiration = DateTime.Now.AddMinutes(Convert.ToDouble(
                jwtSettings.GetSection("lifetime").Value));

            var token = new JwtSecurityToken(
                issuer: jwtSettings.GetSection("Issuer").Value,
                claims: claims,
                expires: expiration,
                signingCredentials: signingCredentials
                );

            return token;
        }
        private async Task<List<Claim>> GetClaims()
        {
            var claims = new List<Claim>

       {
           new Claim(ClaimTypes.Name, _customer.UserName)
       };

            //var roles = await _userManager.GetRolesAsync(_customer);

            //foreach (var role in roles)
            //{
            //    claims.Add(new Claim(ClaimTypes.Role, role));
            //}

            return claims;
        }
        //private SigningCredentials GetSigningCredentials()
        //{
        //    var key = _configuration.GetValue<String>("Jwt:SecretKey");
        //    var secret = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));

        //    return new SigningCredentials(secret, SecurityAlgorithms.HmacSha256);
        //}
        private SigningCredentials GetSigningCredentials()
        {
            var key = _configuration.GetValue<string>("Jwt:SecretKey");
            if (string.IsNullOrEmpty(key))
            {
                throw new Exception("Secret Key is null or empty.");
            }

            _logger.LogInformation($"Key Length: {key.Length}"); 
            var secret = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));

            return new SigningCredentials(secret, SecurityAlgorithms.HmacSha256);
        }
        public async Task<bool> ValidateUser(CustomerDto customerDto)
        {
            _customer = await _userManager.FindByNameAsync(customerDto.Email);
            var validPassword = await _userManager.CheckPasswordAsync(_customer, customerDto.Password);
            return (_customer != null && validPassword);
        }
        public async Task<string> CreateRefreshToken()
        {
            await _userManager.RemoveAuthenticationTokenAsync(_customer, "BankServer", "RefreshToken");
            var newRefreshToken = await _userManager.GenerateUserTokenAsync(_customer, "BankServer", "RefreshToken");
            var result = await _userManager.SetAuthenticationTokenAsync(_customer, "BankServer", "RefreshToken", newRefreshToken);
            return newRefreshToken;
        }
        public async Task<TokenRequest> VerifyRefreshToken(TokenRequest request)
        {
            var jwtSecurityTokenHandler = new JwtSecurityTokenHandler();
            var tokenContent = jwtSecurityTokenHandler.ReadJwtToken(request.Token);
            var username = tokenContent.Claims.ToList().FirstOrDefault(q => q.Type == ClaimTypes.Name)?.Value;
            _customer = await _userManager.FindByNameAsync(username);
            try
            {
                var isValid = await _userManager.VerifyUserTokenAsync(_customer, "BankServer", "RefreshToken", request.RefreshToken);
                if (isValid)
                {
                    return new TokenRequest { Token = await CreateToken(), RefreshToken = await CreateRefreshToken() };
                }
                await _userManager.UpdateSecurityStampAsync(_customer);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return null;
        }
    }
}