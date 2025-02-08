using Microsoft.EntityFrameworkCore.Query;
using Microsoft.EntityFrameworkCore;
using static BankServer.Repositories.Interfaces.IGenericRepository;
using System.Linq.Expressions;
using BankServer.Models;

namespace BankServer.Repositories.Implementation
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        private readonly ApiDbContext _dbcontext;
        private readonly DbSet<T> _db;
        public GenericRepository(ApiDbContext dbContext)
        {
            _dbcontext = dbContext;
            _db = _dbcontext.Set<T>();

        }
        public async Task Delete(int id)
        {
            var entity = await _db.FindAsync(id);
            _db.Remove(entity);
        }
        public void DeleteRange(IEnumerable<T> entities)
        {
            _db.RemoveRange(entities);
        }
        public async Task<T> Get(Expression<Func<T, bool>> expression, Func<IQueryable<T>, IIncludableQueryable<T, object>> include = null)
        {
            IQueryable<T> query = _db;
            if (include != null)
            {
                query = include(query);
            }
            return query.AsNoTracking().FirstOrDefault(expression);
        }
        public async Task<IList<T>> GetAll(Expression<Func<T, bool>> expression = null, Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null, Func<IQueryable<T>, IIncludableQueryable<T, object>> include = null)
        {
            IQueryable<T> query = _db;
            if (expression != null)
            {
                query = query.Where(expression);
            }
            if (include != null)
            {
                query = include(query);
            }
            if (orderBy != null)
            {
                query = orderBy(query);
            }
            return await query.AsNoTracking().ToListAsync();
        }
        public async Task Insert(T entity)
        {
            await _db.AddAsync(entity);
        }
        public async Task InsertRange(IEnumerable<T> entities)
        {
            await _db.AddRangeAsync(entities);
        }
        public void Update(T entity)
        {
            _db.Attach(entity);
            _dbcontext.Entry(entity).State = EntityState.Modified;
        }
    }
    
}
