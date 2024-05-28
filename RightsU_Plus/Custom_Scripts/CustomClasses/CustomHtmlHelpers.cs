using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
namespace RightsU_Entities
{
    public static class CustomHtmlHelpers
    {
        public static MvcHtmlString Image(this HtmlHelper htmlHelper, string id, string name, string src, string alt, string style)
        {
            var imageTag = new TagBuilder("img");
            if (!string.IsNullOrEmpty(id))
                imageTag.MergeAttribute("id", id);
            if (!string.IsNullOrEmpty(name))
                imageTag.MergeAttribute("name", name);
            imageTag.MergeAttribute("src", src);
            imageTag.MergeAttribute("alt", alt);
            if (!string.IsNullOrEmpty(style))
                imageTag.MergeAttribute("style", style);

            return new MvcHtmlString(imageTag.ToString(TagRenderMode.SelfClosing));
        }

        public static MvcHtmlString DropdownGroup(this HtmlHelper htmlHelper, List<GroupItem> lstItems, string id, string name, string className, bool isMultiple)
        {
            string[] groupNames = lstItems.Select(s => s.GroupName).Distinct().ToArray();
            StringBuilder sb = new StringBuilder();
            foreach(string groupName in groupNames)
            {
                sb.Append("<optgroup label = '" + groupName + "'>");
                List<GroupItem> items = lstItems.Where(s => s.GroupName == groupName).ToList();
                foreach (GroupItem item in items)
                {
                    sb.Append("<option value = '" + item.Value + "' class = '" + (item.isSelected ? "selected" : "" ) + "' > " + item.Text + " </ option >");
                }
                sb.Append("</optgroup>");
            }
            string select = "<select name='" + name +"' id = '" + id +"' " + (isMultiple ? "multiple" : "") + " class='" + className + "'>";
            string select1 = "<select" + ( (string.IsNullOrEmpty(name.Trim())) ? "" : " name = '" + name + "'" ) +
                 ((string.IsNullOrEmpty(id.Trim())) ? "" : " ID = '" + id + "'") +
                 ((string.IsNullOrEmpty(className.Trim())) ? "" : " class = '" + className + "'") +
                (isMultiple ? " multiple" : "") + ">";
            select = select + sb.ToString() + "</select>";
            return new MvcHtmlString(select);
        }
        public static string getGroupHtml(List<GroupItem> lstItems)
        {
            string[] groupNames = lstItems.Select(s => s.GroupName).Distinct().ToArray();
            StringBuilder sb = new StringBuilder();
            foreach (string groupName in groupNames)
            {
                sb.Append("<optgroup label = '" + groupName + "'>");
                List<GroupItem> items = lstItems.Where(s => s.GroupName == groupName).ToList();
                foreach (GroupItem item in items)
                {
                    sb.Append("<option value = '" + item.Value + "' " + (item.isSelected ? "" : "") + " > " + item.Text + " </ option >");
                }
                sb.Append("</optgroup>");
            }
            return sb.ToString();
        }

    }
}
