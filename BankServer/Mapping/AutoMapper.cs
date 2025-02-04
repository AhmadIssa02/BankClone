using AutoMapper;
using BankServer.Models.Domain;
using BankServer.Models.DTOs;
namespace BankServer.Mapping
{
    public class AutoMapper : Profile
    {
        public AutoMapper() { 
            CreateMap<Customer, CustomerDto>();
            CreateMap<Customer, CustomerDto>().ReverseMap();

        }
    }
}
