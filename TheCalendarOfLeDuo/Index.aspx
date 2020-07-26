<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="TheCalendarOfLeDuo.Index" %>

<!DOCTYPE html>

<html>
<head>
    <title>乐多的日历</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="Generator" content="EditPlus">
    <meta name="Author" content="">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <style>

        thead td {
            text-align: center;
            font-size: 50px;
        }

        thead td, tbody td {
            /*   width: 200px;
            height: 200px;*/
            width: 76px;
            height: 58px;
            background-repeat: no-repeat;
            background-position:right bottom;
            /*position: relative*/
        }

            thead td.sun, thead td.sta {
                color: #eec877;
            }

        tbody td {
            border: 1px solid #eee;
            vertical-align: bottom;
        }

        textarea {
            width: 96%;
            height: 99%;
            overflow: auto;
            word-break: break-all;
           /* resize: none;*/
            background: transparent;
            border-style: none;
            /*position: absolute;*/
        }

        .cal-box {
            float: left;
            /*display: inline-block;*/
            width: 50%;
            height: 40%;
            word-wrap: break-word;
           
        }
    </style>

</head>

<body>
    ctrl+s:保存数据
     <br />
    ctrl+q:退出显示备注内容模式, 再按 ctrl+q 进入显示备注内容模式
    <br /><br />
    <!--提示框字体颜色参考
        goldenrod,darkorange,blue,blueviolet,brown
        -->
   <div style="width:400px;height:200px;position:fixed;border:1px solid lightgray;
opacity: 0.6; background-color:lightgray;font-size:28px;color:brown;
left:-500px" id="showmore"></div>
    <div class="container" id="container">




    </div>

    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/FileSaver.js"></script>
    <script src="/js/lunarVSsolar.js"></script>
    <%--<script src="data.js"></script>--%>

    <script>

        let daysImg = {
            "1": "./imgs/1.jpg",
            "2": "./imgs/2.jpg",
            "3": "./imgs/3.jpg",
            "4": "./imgs/4.png",
            "5": "./imgs/5.png",
            "6": "./imgs/6.png",
            "7": "./imgs/7.png",
            "8": "./imgs/8.png",
            "9": "./imgs/9.png",
            "10": "./imgs/10.png",
            "11": "./imgs/11.png",
            "12": "./imgs/12.png",
            "13": "./imgs/13.png",
            "14": "./imgs/14.png",
            "15": "./imgs/15.png",
            "16": "./imgs/16.png",
            "17": "./imgs/17.png",
            "18": "./imgs/18.png",
            "19": "./imgs/19.png",
            "20": "./imgs/20.png",
            "21": "./imgs/21.png",
            "22": "./imgs/22.png",
            "23": "./imgs/23.png",
            "24": "./imgs/24.png",
            "25": "./imgs/25.png",
            "26": "./imgs/26.png",
            "27": "./imgs/27.png",
            "28": "./imgs/28.png",
            "29": "./imgs/29.png",
            "30": "./imgs/30.png",
            "31": "./imgs/31.png"
        };

        $(function ()
        {
            let tables = "";
            for (let i = 7; i < 13; i++)
            {
                tables += `
                                                                                                                                      <div class="cal-box">
                                                                                                                                                 2020年${i}月
                                                                                                                                                 <table>
                                                                                                                                                     <thead>
                                                                                                                                                         <tr>

                                                                                                                                                             <td>一</td>
                                                                                                                                                             <td>二</td>
                                                                                                                                                             <td>三</td>
                                                                                                                                                             <td>四</td>
                                                                                                                                                             <td>五</td>
                                                                                                                                                             <td class="sta">六</td>
                                                                                                                                                             <td class="sun">日</td>
                                                                                                                                                         </tr>
                                                                                                                                                     </thead>
                                                                                                                                                     <tbody id="month${i}_2020">

                                                                                                                                                     </tbody>

                                                                                                                                                 </table>

                                                                                                                                             </div>
                                                                                                                                `;
            }

            $("#container").html(tables);

            let trs = "";
            for (let i = 0; i < 6; i++)
            {
                trs += `<tr>

                                                                                                                             <td ></td>

                                                                                                                             <td></td>

                                                                                                                             <td></td>

                                                                                                                             <td></td>

                                                                                                                             <td></td>

                                                                                                                             <td></td>

                                                                                                                             <td></td>

                                                                                                                         </tr>`;
            }
            $("tbody").html(trs);


            for (let i = 7; i < 13; i++)
            {
                //渲染年月日历
                initCal(2020, i);
            }

            //去除最后一空白行
            //$.each($("tr"), function (index, item)
            //{
            //    let trHtml = $(item).html();
            //    if (trHtml.indexOf('textarea') < 0 && trHtml.indexOf('一') < 0)
            //    {
            //        $(item).remove();
            //    }
            //})
            <%= RiLiJson %>
            //if (typeof (rilidata) != undefined)
            //{
            //    setTimeout(function ()
            //    {
            //        for (key in rilidata)
            //        {
            //            $('#' + key).val(rilidata[key]);
            //        }
            //    }, 300);
                
            //}

            setTimeout(onTextAreaMouseIn, 1000);
        })

        function initCal(yy, mm)
        {
            var days = 0;
            if (mm == 2 && yy % 4 == 0 && yy % 100 !== 0)
            {
                days = 28;
            } else if (mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10 || mm == 12)
            {
                days = 31;
            } else if (mm == 4 || mm == 6 || mm == 9 || mm == 11)
            {
                days = 30;
            } else
            {
                days = 29;
            }

            var m = mm < 3 ? (mm == 1 ? 13 : 14) : mm;
            yy = m > 12 ? yy - 1 : yy;
            var c = Number(yy.toString().substring(0, 2)),
                y = Number(yy.toString().substring(2, 4)),
                d = 1;
            //蔡勒公式
            var week = y + parseInt(y / 4) + parseInt(c / 4) - 2 * c + parseInt(26 * (m + 1) / 10) + d - 1;

            week = week < 0 ? (week % 7 + 7) % 7 : week % 7;

            var $td = $(`#month${mm}_${yy}`).find('td');

            //for (var i = 0; i < 42; i++)
            //{
            //    $td.eq(i).text('');　　　　//清空原来的text文本
            //}


            let nextLine = week % 7 + 0 - 1 < 0;//解决1号出现在最后一行的问题
            for (var i = 0; i < days; i++)
            {
                let index = i + 1;
                index = index + "";
                let img = daysImg[index];

                let yu = week % 7 + i - 1;
                let nongli = Lunar.toLunar(yy, mm, i+1); 
                //$td.data("lunarMonth", nongli[5]);
                //$td.data("lunarDay", nongli[6]);
                let textarea = `<textarea  id='${yy}_${mm}_${i + 1}'></textarea>`;
                if (nextLine)
                {
                    //$td.eq(7 + yu).text(i + 1).css("background-image", "url(" + img + ")");
                   
                    let $currentTd = $td.eq(7 + yu);
                    $currentTd.html(textarea).css("background-image", "url(" + img + ")");
                    //$currentTd.data("lunarMonth", nongli[5]);
                    //$currentTd.data("lunarDay", nongli[6]);
                    $currentTd.attr("title", nongli[5] + nongli[6]);
                }
                else
                {

                    //$td.eq(yu).text(i + 1).css("background-image", "url(" + img + ")");
                    //$td.eq(yu).html(textarea).css("background-image", "url(" + img + ")");
                    $currentTd = $td.eq(yu);
                    $currentTd.html(textarea).css("background-image", "url(" + img + ")");
                    //$currentTd.data("lunarMonth", nongli[5]);
                    //$currentTd.data("lunarDay", nongli[6]);

                    $currentTd.attr("title", nongli[5] + nongli[6]);
                }
                
            }



        }

        // ctrl+s 保存
        function save()
        {
            let data = {};
            $.each($("textarea"), function (index, item)
            {
                let value = $(item).val();
                value = $.trim(value);
                if (value)
                {
                    let key = $(item).attr("id");
                    data[key] = value;

                }

            });

            //console.log(data);
            //var content = JSON.stringify(data, null, '\t');
            //content = `var rilidata=` + content+";";
            //var blob = new Blob([content], { type: "text/plain;charset=UTF-8" });
            //saveAs(blob, "data.js");
            //地址栏有长度限制
            //$.post("/Index.aspx?action=savedata&data=" + JSON.stringify(data)).then(function (response)
            let jsonData = { "action": "savedata", data: JSON.stringify(data) };
            $.post("/Index.aspx", jsonData).then(function (response)
            {
                //console.log(response);
                if (response == "ok")
                {
                    document.title = "保存成功";
                    setTimeout(() => { document.title = "乐多的日历"; },2000);
                }
            });
        }

        //重写 ctrl 组合键
        document.addEventListener('keydown', function (e)
        {
            let ctrlKey = navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey;
            if (ctrlKey)
            {
                if (e.keyCode == 83)
                {
                    //ctrl+s 保存
                    e.preventDefault();
                    save();
                }
                else if (e.keyCode == 81)
                {
                    //ctrl+q 退出提示框
                    //e.preventDefault();
                    $("#showmore").css({ "left": "-500px" });
                    isShowMore = !isShowMore;
                }
            }
            
        });
        


        //ctrl+q:退出显示textarea内容模式, 再按 ctrl+q 进入显示textarea内容模式
        let isShowMore = true; // 页面打开后,默认显示textarea内容模式
        function onTextAreaMouseIn()
        {
            $("textarea").mouseover(function (e)
            {
                if (!isShowMore) return;

                var xx = e.originalEvent.x || e.originalEvent.layerX || 0;
                var yy = e.originalEvent.y || e.originalEvent.layerY || 0;
                //$(this).text(xx + '---' + yy);
                xx += 80;
                if (xx > 1000)
                {
                    xx -= 520;
                }
                let text = $(this).val();
                //console.log(text);
                //yy += 5;
                if (text)
                {
                    $("#showmore").css({ "left": xx + "px", "top": yy + "px", }).text(text);
                }
                else
                {
                    $("#showmore").css({ "left": "-500px" }).text("");
                }
                
            });
            
        }
    </script>
</body>
</html>
