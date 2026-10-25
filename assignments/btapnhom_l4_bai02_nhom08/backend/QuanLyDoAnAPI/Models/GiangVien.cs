using System;
using System.Collections.Generic;

namespace QuanLyDoAnAPI.Models;

public partial class GiangVien
{
    public string MaGiangVien { get; set; } = null!;

    public string HoTen { get; set; } = null!;

    public string? HocVi { get; set; }

    public string? Email { get; set; }

    public virtual ICollection<DeTai> DeTai { get; set; } = new List<DeTai>();
}
