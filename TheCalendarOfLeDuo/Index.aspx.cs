using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TheCalendarOfLeDuo
{
    public partial class Index : System.Web.UI.Page
    {
        protected string RiLiJson = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
           string riliPath=  Server.MapPath("rilidata.txt");
            FileInfo riliDataFile = new FileInfo(riliPath);
            if(!riliDataFile.Exists)
            {
                riliDataFile.Create();
            }
            string riliJson=File.ReadAllText(riliPath);
            if(!string.IsNullOrEmpty(riliJson))
            {
                RiLiJson = $"let rilidata={riliJson};"; 
            }
            //当页面上有服务器端控件时，IsPostBack才有用
            //if(IsPostBack)
            string action = Request["action"];
            if(string.IsNullOrEmpty(action))
            {
                string dataPath = Server.MapPath(@"/App_Data/data.txt");
                string data = File.ReadAllText(dataPath, Encoding.UTF8);
                //页面第一次打开
                RiLiJson = $"let rilidata={data};";
            }
            else
            {
                //异步请求
                string data = Request["data"];
                SaveData(data);
                Response.Write("ok");
                Response.End();
            }
        }

        private string SaveData(string data)
        {
            string dataPath=  Server.MapPath(@"/App_Data/data.txt");
            // File.ReadAllText(dataPath);
            //FileInfo dataFile = new FileInfo(dataPath);
            //if(!dataFile.Exists)
            //{
            //    //using (var filestream = dataFile.Create())
            //    //{
            //    //释放对文件的锁定
            //    //}
            //    var filestream = dataFile.Create();
            //    filestream.Dispose();
            //}
            File.WriteAllText(dataPath, data, Encoding.UTF8);
            return data;
        }
    }
}