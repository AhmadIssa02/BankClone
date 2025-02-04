using AutoMapper;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
namespace BankServer.Mapping
{
    public class AutoMapper : Profile
    {
        public AutoMapper() { 
            CreateMap<Customer, RegisterCustomerDto>();
            CreateMap<Customer, EditCustomerPasswordDto>();
            CreateMap<Customer, RegisterCustomerDto>().ReverseMap();
            CreateMap<Customer, EditCustomerPasswordDto>().ReverseMap();

        }
    }
}
