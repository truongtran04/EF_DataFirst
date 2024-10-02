using DataFirst.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DataFirst.Controllers
{
    public class ImagesController : Controller
    {
        // GET: Images
        public ActionResult Index()
        {
            TESTEntities db = new TESTEntities();
            List<Image> images = db.Images.ToList();

            return View(images);
        }
        public ActionResult Create()
        {
            TESTEntities db = new TESTEntities();
            ViewBag.Clothes = db.Clothes.ToList();
            ViewBag.Colors = db.Colors.ToList();

            return View();
        }

        [HttpPost]
        public ActionResult Create(Image img, HttpPostedFileBase MainImage, HttpPostedFileBase SecondaryImage1, HttpPostedFileBase SecondaryImage2, HttpPostedFileBase SecondaryImage3)
        {
            TESTEntities db = new TESTEntities();


            // Đường dẫn lưu ảnh
            string imgFolderPath = Server.MapPath("~/Images/");

            // Xử lý ảnh chính (Main Image)
            if (MainImage != null && MainImage.ContentLength > 0)
            {
                string mainImageFileName = Path.GetFileName(MainImage.FileName);
                string mainImagePath = Path.Combine(imgFolderPath, mainImageFileName);
                MainImage.SaveAs(mainImagePath);
                img.MainImage = "/Images/" + mainImageFileName;  // Lưu đường dẫn ảnh chính vào đối tượng img
            }

            // Xử lý SecondaryImage1
            if (SecondaryImage1 != null && SecondaryImage1.ContentLength > 0)
            {
                string secondaryImageFileName1 = Path.GetFileName(SecondaryImage1.FileName);
                string secondaryImagePath1 = Path.Combine(imgFolderPath, secondaryImageFileName1);
                SecondaryImage1.SaveAs(secondaryImagePath1);
                img.SecondaryImage1 = "/Images/" + secondaryImageFileName1;  // Lưu đường dẫn ảnh phụ 1 vào đối tượng img
            }

            // Xử lý SecondaryImage2
            if (SecondaryImage2 != null && SecondaryImage2.ContentLength > 0)
            {
                string secondaryImageFileName2 = Path.GetFileName(SecondaryImage2.FileName);
                string secondaryImagePath2 = Path.Combine(imgFolderPath, secondaryImageFileName2);
                SecondaryImage2.SaveAs(secondaryImagePath2);
                img.SecondaryImage2 = "/Images/" + secondaryImageFileName2;  // Lưu đường dẫn ảnh phụ 2 vào đối tượng img
            }

            // Xử lý SecondaryImage3
            if (SecondaryImage3 != null && SecondaryImage3.ContentLength > 0)
            {
                string secondaryImageFileName3 = Path.GetFileName(SecondaryImage3.FileName);
                string secondaryImagePath3 = Path.Combine(imgFolderPath, secondaryImageFileName3);
                SecondaryImage3.SaveAs(secondaryImagePath3);
                img.SecondaryImage3 = "/Images/" + secondaryImageFileName3;  // Lưu đường dẫn ảnh phụ 3 vào đối tượng img
            }

            // Lưu đối tượng img vào cơ sở dữ liệu
            img.ImageID = "IMG000";
            db.Images.Add(img);
            db.SaveChanges();

            return RedirectToAction("Index");


        }


    }
}