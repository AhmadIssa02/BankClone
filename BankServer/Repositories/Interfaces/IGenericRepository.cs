﻿using Microsoft.EntityFrameworkCore.Query;
using System.Linq.Expressions;


namespace BankServer.Repositories.Interfaces
{
    public interface IGenericRepository
    {
        public interface IGenericRepository<T> where T : class
        {
            Task<T> Get(Expression<Func<T, bool>> expression,
                Func<IQueryable<T>, IIncludableQueryable<T, object>> include = null);
            Task<IList<T>> GetAll(Expression<Func<T, bool>> expression = null,
                Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null,
                Func<IQueryable<T>, IIncludableQueryable<T, object>> include = null
                );
            Task Insert(T entity);
            Task InsertRange(IEnumerable<T> entities);
            Task Delete(int id);
            void DeleteRange(IEnumerable<T> entities);
            void Update(T entity);
        }
    }
}

