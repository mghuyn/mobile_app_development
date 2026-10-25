
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnAPI.Data;
using QuanLyDoAnAPI.Models;

namespace QuanLyDoAnAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class LoaiDoAnController : ControllerBase
{
    private readonly QuanLyDoAnDbContext _context;

    public LoaiDoAnController(QuanLyDoAnDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Set<LoaiDoAn>()
            .AsNoTracking()
            .OrderBy(x => x.MaLoaiDoAn)
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var data = await _context.Set<LoaiDoAn>()
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.MaLoaiDoAn == id);

        if (data == null)
            return NotFound(new { message = "Không tìm thấy loại đồ án" });

        return Ok(data);
    }
}
