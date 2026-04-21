using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CategoriesController(AppDbContext context)
        {
            _context = context;
        }

        // GET/
        [HttpGet]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _context.Categories
                .Include(c => c.Subcategories)
                .ToListAsync();

            // 200 OK
            return Ok(categories);
        }
    }
}
