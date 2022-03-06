using System.Diagnostics;
using System.IO.Compression;

HttpClient httpClient = new();
const string UNIKEY_X64_DOWNLOAD_URL = "https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip";
const string UNIKEY_X86_DOWNLOAD_URL = "https://www.unikey.org/assets/release/unikey43RC5-200929-win32.zip";
const string UNIKEY_PROCESS_NAME = "UnikeyNT.exe";

// Get UnikeyNT.exe with process type
var appDataDirectory = AppDomain.CurrentDomain.BaseDirectory;
var unikeyNTProcessDirectory = Path.Combine(
    appDataDirectory,
    "Apps",
    Environment.Is64BitProcess ? "x64" : "x86");
var unikeyNTProcessExePath = Path.Combine(
    unikeyNTProcessDirectory,
    UNIKEY_PROCESS_NAME);

// Download app if not exist in container
if (!File.Exists(unikeyNTProcessExePath))
{
    await DownloadUnikeyToInstalledLocationAsync(unikeyNTProcessDirectory, Environment.Is64BitProcess);
}

// Clean all UnikeyNT processes
var processNameWithOutExtension = Path.GetFileNameWithoutExtension(unikeyNTProcessExePath);
var unikeyNTs = Process.GetProcessesByName(processNameWithOutExtension);
Array.ForEach(unikeyNTs, unikeyNT => unikeyNT.Kill(true));

// Start with new one
var unikeyNtProcessInfo = new ProcessStartInfo()
{
    FileName = unikeyNTProcessExePath,
    WorkingDirectory = unikeyNTProcessDirectory
};

Process.Start(unikeyNtProcessInfo);

async Task DownloadUnikeyToInstalledLocationAsync(string localPath, bool is64Bit)
{
    var downloadUrl = is64Bit ? UNIKEY_X64_DOWNLOAD_URL : UNIKEY_X86_DOWNLOAD_URL;
    var downloadStream = await httpClient.GetStreamAsync(downloadUrl);

    // Unzip
    using var archiver = new ZipArchive(downloadStream, ZipArchiveMode.Read);
    archiver.ExtractToDirectory(localPath, true);
}