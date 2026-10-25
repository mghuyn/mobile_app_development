using System;
using System.Collections.Generic;

namespace QuanLyDoAnAPI.Models;

public partial class LoaiDoAn
{
    public string MaLoaiDoAn { get; set; } = null!;

    public string TenLoaiDoAn { get; set; } = null!;

    public string? MoTa { get; set; }

    public virtual ICollection<DeTai> DeTai { get; set; } = new List<DeTai>();
}
