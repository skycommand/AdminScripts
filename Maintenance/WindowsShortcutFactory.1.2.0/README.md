# WindowsShortcutFactory

This is a simple .NET library for creating or modifying Windows shortcut files. It has no dependencies, and doesn't use .NET COM Interop or Windows Script Host, instead calling into the native IShellLink interface directly.

## Creating a Shortcut

This example creates a shortcut to `C:\my\program\target.exe`:

```csharp
using var shortcut = new WindowsShortcut
{
    Path = @"C:\my\program\target.exe",
    Description = "Just a simple shortcut to target.exe."
};

shortcut.Save(@"C:\temp\MyShortcut.lnk");
```
