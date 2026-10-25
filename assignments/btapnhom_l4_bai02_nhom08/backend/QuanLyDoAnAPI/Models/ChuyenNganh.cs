using System;
using System.Collections.Generic;

namespace QuanLyDoAnAPI.Models;

public partial class ChuyenNganh
{
    public string MaChuyenNganh { get; set; } = null!;

    public string TenChuyenNganh { get; set; } = null!;

    public string? MoTa { get; set; }

    public virtual ICollection<DeTai> DeTai { get; set; } = new List<DeTai>();
}
