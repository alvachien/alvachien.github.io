---
layout: post
title: "[.NET] C#中SendMessage通过LPARAM传递Structure"
date: 2009-11-03 23:57
author: alvachien
comments: true
categories: [C++, LPARAM, Microsoft.NET, SendMessage, Windows Platform, 技术Tips]
---
<div id="bp-5CD1AA99D25FD840_938-content">

这两天一直被一个问题烦着：SendMessage在C#始终不正常。因为SendMessage是标准的WinAPI，在C/C++中，Structure可以很方便通过取地址传递给SendMessage，比如Richedit中常用的EM_GETCHARFORMAT消息：
```C++
SendMessage( hWnd, EM_GETCHARFORMAT, ( WPARAM)SCF_SELECTION, (LPARAM)cfm );
```

在C#乃至CLR中，并没有对应的CHARFORMAT2，所以必须自己依照MSDN中CHARFORMAT2的C++定义：
```C++
[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
private struct CHARFORMAT2
{
    public int cbSize;
    public uint dwMask;
    public uint dwEffects;
    public int yHeight;
    public int yOffset;
    public int crTextColor;
    public byte bCharSet;
    public byte bPitchAndFamily;
    [MarshalAs(UnmanagedType.ByValArray, SizeConst = 32)]
    public char[] szFaceName;
    public short wWeight;
    public short sSpacing;
    public int crBackColor;
    public int LCID;
    public uint dwReserved;
    public short sStyle;
    public short wKerning;
    public byte bUnderlineType;
    public byte bAnimation;
    public byte bRevAuthor;
    public byte bReserved1;
}
```
LayoutKind和UnmanagedType.ByValArray是基本的Marshal常识，偶想强调的是CharSet这个Attribute，尽管CLR默认是CharSet.Auto，但部分语言会override这个属性，**C#中就会默认改为CharSet.Ansi**，这也是磕绊偶两天的罪魁祸首。

Structure定义好了，DllImport就比较方便，同样，**必须制定相同的CharSet**。因为Microsot在Windows NT开始已经在内核全部Unicode化，使用Ansi的CharSet会使得操作系统额外多出两部CharSet之间的转换，所以推荐Unicode或者Auto，Auto模式只在Windows 98和Windows ME中是Ansi。

对于SendMessage这个定义在USER32.DLL中的导出函数来说，可以定义很多不同的DllImport，常用的有如：
```C++
[DllImport("user32", CharSet = CharSet.Auto, SetLastError = true)]
private static extern int SendMessage(HandleRef hWnd, int msg, int wParam, int lParam);

[DllImport("user32", CharSet = CharSet.Auto)]
private static extern int SendMessage(HandleRef hWnd, int msg, int wParam, ref CHARFORMAT2 lParam);

[DllImport("user32", CharSet = CharSet.Auto, SetLastError = true)]
private static extern IntPtr SendMessage(HandleRef hWnd, int msg, Int32 wParam, ref IntPtr lParam);

[DllImport("USER32", EntryPoint = "SendMessage", ExactSpelling = true, CharSet = CharSet.Auto, SetLastError = true)]
private static extern IntPtr SendMessage(IntPtr hWnd, int msg, IntPtr wp, IntPtr lp);
```

最简单的方法莫过于第二种定义，它直接在LPARAM参数中使用了CHARFORMAT2的ref。C#编译器会直接生成内部GCHandle以完成Unmanaged和Managed Heap之间的数据转换。对于别的Structure，可以定义其自己的DllImport，并为LPARAM使用自身的Structure。

对于其他三种定义，需要自己转换IntPtr了。其方法无外乎以下两种：
```C++
GCHandle gch = GCHandle.Alloc(fmt);
IntPtr lParam = GCHandle.ToIntPtr(gch);
SendMessage(new HandleRef(this, Handle), EM_GETCHARFORMAT, SCF_SELECTION, ref lParam);
fmt = (CHARFORMAT2)Marshal.PtrToStructure(lParam, typeof(CHARFORMAT2));
gch.Free();
```

或：
```C++
IntPtr lparam = IntPtr.Zero;
lparam = Marshal.AllocCoTaskMem(Marshal.SizeOf(fmtRange));
Marshal.StructureToPtr(fmtRange, lparam, false);
SendMessage(Handle, EM_FORMATRANGE, wparam, lparam);
Marshal.FreeCoTaskMem(lparam);
```

特别的，是对于输出为String的WinAPI，可以使用StringBuilder，而不需要制定ref或者out。如：
```C++
[DllImport("user32.dll", EntryPoint="SendMessage")]
private static extern Int32 SendMessage (IntPtr hwnd, Int32 wMsg, Int32 wParam, StringBuilder lParam);
```

调用时：
```C++
const Int32 MAX_SIZE = 1024;
StringBuilder buffer = new StringBuilder(MAX_SIZE);
SendMessage(tb_Input.Handle, WM_GETTEXT, MAX_SIZE, buffer);
```

Issued by Alva Chien
2009.11.3

