
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnAPI.Data;
using QuanLyDoAnAPI.Models;

namespace QuanLyDoAnAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DeTaiController : ControllerBase
{
    private readonly QuanLyDoAnDbContext _context;

    public DeTaiController(QuanLyDoAnDbContext context)
    {
        _context = context;
    }

    
[HttpGet]
public async Task<IActionResult> GetAll(
    [FromQuery] string? maLoaiDoAn,
    [FromQuery] string? maChuyenNganh,
    [FromQuery] string? keyword)
{
    var query =
        from dt in _context.Set<DeTai>()
        join loai in _context.Set<LoaiDoAn>()
            on dt.MaLoaiDoAn equals loai.MaLoaiDoAn
        join cn in _context.Set<ChuyenNganh>()
            on dt.MaChuyenNganh equals cn.MaChuyenNganh
        join gv in _context.Set<GiangVien>()
            on dt.MaGiangVien equals gv.MaGiangVien
        select new
        {
            dt.MaDeTai,
            dt.TenDeTai,
            dt.SoSinhVienToiDa,

            dt.MaLoaiDoAn,
            loai.TenLoaiDoAn,

            dt.MaChuyenNganh,
            cn.TenChuyenNganh,

            dt.MaGiangVien,
            GiangVienHuongDan = gv.HoTen,

            // Them hoc vi giang vien
            gv.HocVi,
            gv.Email,

            dt.YeuCau,
            dt.MoTa
        };

    // Loc theo loai do an
    if (!string.IsNullOrWhiteSpace(maLoaiDoAn))
    {
        query = query.Where(x =>
            x.MaLoaiDoAn == maLoaiDoAn);
    }

    // Loc theo chuyen nganh
    if (!string.IsNullOrWhiteSpace(maChuyenNganh))
    {
        query = query.Where(x =>
            x.MaChuyenNganh == maChuyenNganh);
    }

    // Tim kiem theo ten de tai
    if (!string.IsNullOrWhiteSpace(keyword))
    {
        query = query.Where(x =>
            x.TenDeTai.Contains(keyword));
    }

    var data = await query.AsNoTracking()
        .OrderBy(x => x.MaDeTai)
        .ToListAsync();

    return Ok(data);
}


    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var data = await (
            from dt in _context.Set<DeTai>()
            join loai in _context.Set<LoaiDoAn>()
                on dt.MaLoaiDoAn equals loai.MaLoaiDoAn
            join cn in _context.Set<ChuyenNganh>()
                on dt.MaChuyenNganh equals cn.MaChuyenNganh
            join gv in _context.Set<GiangVien>()
                on dt.MaGiangVien equals gv.MaGiangVien
            where dt.MaDeTai == id
            select new
            {
                dt.MaDeTai,
                dt.TenDeTai,
                dt.SoSinhVienToiDa,
                loai.TenLoaiDoAn,
                cn.TenChuyenNganh,
                GiangVienHuongDan = gv.HoTen,
                gv.HocVi,
                gv.Email,
                dt.YeuCau,
                dt.MoTa
            }
        ).AsNoTracking().FirstOrDefaultAsync();

        if (data == null)
            return NotFound(new { message = "Không tìm thấy đề tài" });

        return Ok(data);
    }
}
