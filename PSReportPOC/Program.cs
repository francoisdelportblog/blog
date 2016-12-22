using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Microsoft.Reporting.WinForms;


namespace ReportPOC
{
    class Program
    {
        static void Main(string[] args)
        {
            RunReport();
        }

        private static void RunReport()
        {
            var rv = new Microsoft.Reporting.WinForms.ReportViewer();

            //set the report rdlc file
            var data = new List<ReportData>
            {
                new ReportData() {ServerName = "Server1", CPUAvail = 150, CPUUsed = 123},
                new ReportData() {ServerName = "Server2", CPUAvail = 120, CPUUsed = 100},
                new ReportData() {ServerName = "Server3", CPUAvail = 140, CPUUsed = 103},
                new ReportData() {ServerName = "Server4", CPUAvail = 190, CPUUsed = 183},
                new ReportData() {ServerName = "Server5", CPUAvail = 50, CPUUsed = 34}
            };
            var rep = new Microsoft.Reporting.WinForms.ReportDataSource("ReportDS", data);

            var x = new ReportDataSource();

            rv.LocalReport.ReportPath = "POC.rdlc";
            rv.LocalReport.DataSources.Add(rep);
            var bytes = rv.LocalReport.Render("WORDOPENXML");

            using (FileStream fs = File.Create("POC.docx"))
            {
                fs.Write(bytes, 0, bytes.Length);
            }

            var bytesxls = rv.LocalReport.Render("EXCEL");

            using (FileStream fs = File.Create("POC.XLS"))
            {
                fs.Write(bytesxls, 0, bytesxls.Length);
            }

            var bytespdf = rv.LocalReport.Render("PDF");

            using (FileStream fs = File.Create("POC.PDF"))
            {
                fs.Write(bytespdf, 0, bytespdf.Length);
            }
    }
}
