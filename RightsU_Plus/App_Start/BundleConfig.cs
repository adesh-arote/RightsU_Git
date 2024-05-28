using System.Web;
using System.Web.Optimization;

namespace RightsU_Plus
{
    public class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/JS_Core").Include(
                        "~/Scripts/jquery-3.0.0.min.js",
                        //"~/Scripts/jquery-3.0.0.js",
                        "~/JS_Core/jquery-ui.min.js",
                        "~/JS_Core/jquery.expander.js",
                        "~/JS_Core/common.concat.js",
                        "~/JS_Core/chosen.jquery.min.js",
                        "~/JS_Core/jquery.pagination.js",
                        "~/JS_Core/jquery.alphanum.min.js"));

            bundles.Add(new StyleBundle("~/bundles/CSS").Include(
                        "~/CSS/jquery-ui.css",
                        "~/CSS/common.css"));

            bundles.Add(new ScriptBundle("~/bundles/Login/JS_Core").Include(
                        //"~/Scripts/jquery-3.0.0.min.js",
                        "~/Scripts/jquery-3.0.0.js",
                        "~/JS_Core/common.concat.js"));

            bundles.Add(new StyleBundle("~/bundles/Login/CSS").Include(
                        "~/CSS/login_page.css",
                        "~/CSS/common.css"));
        }
    }
}