using BankServer.Models;
using BankServer.Models.Domain.BankServer.Models.Domain;
using BankServer.Repositories.Interfaces;
using static BankServer.Repositories.Interfaces.IGenericRepository;

namespace BankServer.Repositories.Implementation
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly ApiDbContext _dbContext;
        private IGenericRepository<AccountBalance> _accountBalances;
        private IGenericRepository<Transaction> _transactions;
        public UnitOfWork(ApiDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        //public IGenericRepository<Employee> Employees => _Employees ??= new GenericRepository<Employee>(_dbContext);
        //public IGenericRepository<Department> Departments => _Departments ??= new GenericRepository<Department>(_dbContext);
        public IGenericRepository<AccountBalance> AccountBalanceRepository => _accountBalances ??= new GenericRepository<AccountBalance>(_dbContext);
        public IGenericRepository<Transaction> TransactionRepository => _transactions ??= new GenericRepository<Transaction>(_dbContext);
        public void Dispose()
        {
            _dbContext.Dispose();
            GC.SuppressFinalize(this);
        }
        public async Task Save()
        {
            await _dbContext?.SaveChangesAsync();
        }
    }
}
