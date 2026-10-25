
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnAPI.Data;
using QuanLyDoAnAPI.Models;

namespace QuanLyDoAnAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ChuyenNganhController : ControllerBase
{
    private readonly QuanLyDoAnDbContext _context;

    public ChuyenNganhController(QuanLyDoAnDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Set<ChuyenNganh>()
            .AsNoTracking()
            .OrderBy(x => x.TenChuyenNganh)
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var data = await _context.Set<ChuyenNganh>()
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.MaChuyenNganh == id);

        if (data == null)
            return NotFound(new { message = "Không tìm thấy chuyên ngành" });

        return Ok(data);
    }
}
