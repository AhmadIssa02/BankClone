using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using BankServer.Models;
using BankServer.Services.Interfaces;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
using AutoMapper;
using System.Security.Claims;


namespace BankServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class AccountController : ControllerBase
    {
        private readonly UserManager<Customer> _userManager;
        private readonly IMapper _mapper;
        //private readonly SignInManager<APIUser> _signInManager;
        private readonly ILogger<AccountController> _logger;
        private readonly IAuthManager _authManager;
        public AccountController(UserManager<Customer> userManager, ILogger<AccountController> logger, IAuthManager authManager, IMapper mapper)
        {
            _userManager = userManager;
            _mapper = mapper;
            //_signInManager = signInManager;
            _logger = logger;
            _authManager = authManager;
        }

        [HttpPost]
        [Route("Register")]
        public async Task<IActionResult> Register(RegisterCustomerDto customerDto)
        {
            if (!IsValidEmail(customerDto.Email))
            {
                return BadRequest("Invalid Email");
            }

            try
            {


                if (!ModelState.IsValid)
                {
                    BadRequest(ModelState);
                }
                var accountNumber = GenerateRandomAccountNumber();
                var iban = GenerateRandomIBAN(accountNumber);

                var customer = _mapper.Map<Customer>(customerDto);
                customer.AccountNumber = accountNumber;
                customer.IBAN = iban;
                customer.UserName = customerDto.Email;
                var result = await _userManager.CreateAsync(customer, customerDto.Password);

                if (!result.Succeeded)
                {

                    foreach (var error in result.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }

                    return BadRequest(ModelState);
                }
                //await _userManager.AddToRolesAsync(user, registerDto.Roles);
                return Accepted();
            }
            catch (Exception ex)
            {
                return Problem(ex.Message, statusCode: 500);
            }

        }
        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login([FromBody] LoginCustomerDto customerDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                if (!await _authManager.ValidateUser(customerDto))
                {
                    return Unauthorized();
                }

                return Accepted(new TokenRequest { Token = await _authManager.CreateToken(), RefreshToken = await _authManager.CreateRefreshToken() });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Something Went Wrong in the {nameof(Login)}");
                return Problem($"Something Went Wrong in the {nameof(Login)}", statusCode: 500);
            }
        }
        [HttpPost]
        [Route("refreshtoken")]
        public async Task<IActionResult> RefreshToken([FromBody] TokenRequest request)
        {
            var tokenRequest = await _authManager.VerifyRefreshToken(request);
            if (tokenRequest is null)
            {
                return Unauthorized();
            }

            return Ok(tokenRequest);
        }
        [HttpPost]
        [Route("logout")]
        //send the access token in the headers so we can extract the claims and find the user 
        public async Task<IActionResult> Logout()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("Invalid token");
                }

                var customer = await _userManager.FindByIdAsync(userId);
                if (customer == null)
                {
                    return Unauthorized("User not found");
                }

                // Invalidate the refresh token
                await _userManager.RemoveAuthenticationTokenAsync(customer, "BankServer", "RefreshToken");

                await _userManager.UpdateSecurityStampAsync(customer);

                return Ok("User logged out successfully");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while logging out.");
                return StatusCode(500, "Internal server error");
            }
        }

        [HttpPost]
        [Route("changePassword")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordDto changePasswordDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
            
                var customer = await _userManager.FindByEmailAsync(changePasswordDto.Email);
                if (customer == null)
                {
                    return Unauthorized("User not found");
                }
                // Validate the old password
                var isPasswordValid = await _userManager.CheckPasswordAsync(customer, changePasswordDto.OldPassword);
                if (!isPasswordValid)
                {
                    return BadRequest("Old password is incorrect");
                }

                // Change the password
                var result = await _userManager.ChangePasswordAsync(customer, changePasswordDto.OldPassword, changePasswordDto.NewPassword);

                if (result.Succeeded)
                {
                    return Ok("Password changed successfully");
                }

                // If there were errors
                foreach (var error in result.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }

                return BadRequest(ModelState);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while changing the password.");
                return StatusCode(500, "Internal server error");
            }
        }


        private int GenerateRandomAccountNumber()
        {
            var random = new Random();
            return random.Next(100000000, 999999999);
        }

        private string GenerateRandomIBAN(int accountNumber)
        {
            var random = new Random();
            // Generate random IBAN in the format: JOXXEFBKXXXXXXXX
            var iban = "JO" + random.Next(10, 99).ToString() + "EFBK" + random.Next(100000000, 999999999).ToString();
            iban += accountNumber.ToString();
            return iban;
        }
        private bool IsValidEmail(string email)
        {
            var emailRegex = new System.Text.RegularExpressions.Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            return emailRegex.IsMatch(email);
        }
    }
}