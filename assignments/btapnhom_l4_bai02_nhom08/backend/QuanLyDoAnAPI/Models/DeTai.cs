using System;
using System.Collections.Generic;

namespace QuanLyDoAnAPI.Models;

public partial class DeTai
{
    public string MaDeTai { get; set; } = null!;

    public string TenDeTai { get; set; } = null!;

    public int SoSinhVienToiDa { get; set; }

    public string MaLoaiDoAn { get; set; } = null!;

    public string MaChuyenNganh { get; set; } = null!;

    public string MaGiangVien { get; set; } = null!;

    public string? YeuCau { get; set; }

    public string? MoTa { get; set; }

    public virtual ChuyenNganh MaChuyenNganhNavigation { get; set; } = null!;

    public virtual GiangVien MaGiangVienNavigation { get; set; } = null!;

    public virtual LoaiDoAn MaLoaiDoAnNavigation { get; set; } = null!;
}
