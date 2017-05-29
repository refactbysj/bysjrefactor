package com.newview.bysj.Selenium2;


import org.junit.AfterClass;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;
import org.testng.annotations.BeforeClass;

import java.util.concurrent.TimeUnit;

import static org.junit.Assert.assertEquals;


/**
 * Created by apple on 17/5/19.
 */
//测试我申报的课题页面
public class TestMyProjectPage {
//    public static void main(String[] args){
//        WebDriver webDriver =  new FirefoxDriver();
//        webDriver.manage().window().maximize();
//        webDriver.manage().timeouts().implicitlyWait(100, TimeUnit.SECONDS);
//        webDriver.get("https://www.baidu.com");
//        webDriver.findElement(By.id("kw")).sendKeys("Selenium");
//        webDriver.findElement(By.id("su")).click();
//        webDriver.quit();
//    }
    private WebDriver driver;
    private String baseUrl;

    //在被@Test注释标注的方法之前运行
    @BeforeClass
    public void before() {
        driver =  new FirefoxDriver();
        baseUrl = "http://localhost:8080/bysj3/login.html";
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
        driver.get(baseUrl);
        driver.manage().window().maximize();
        driver.findElement(By.name("username")).sendKeys("020081");
        driver.findElement(By.name("password")).sendKeys("020081");
        driver.findElement(By.id("submit")).click();
    }

    //只执行一次
    @org.testng.annotations.Test(invocationCount = 1)
    public void test1() throws Exception {
        driver.findElement(By.linkText("选题流程")).click();
        driver.findElement(By.id("url7")).click();
//        WebElement webElement=driver.findElement(By.xpath(".//*[@id='datagrid-row-r1-2-0']/td[9]/div/a"));
//        highlight(driver,webElement);


        //测试删除功能
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//div[@class='panel datagrid easyui-fluid']")).findElement(By.xpath("//table[@class='datagrid-btable']")).findElement(By.xpath("//tr[@id='datagrid-row-r1-2-0']")).findElement(By.xpath("//div[@class='datagrid-cell datagrid-cell-c1-action']")).findElement(By.xpath("//span[text()='删除']")).click();
        driver.switchTo().defaultContent();
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//div[@class='panel window messager-window']")).findElement(By.xpath("//div[@class='dialog-button messager-button']")).findElement(By.xpath("//span[text()='确定']")).click();
        driver.switchTo().defaultContent();
        Thread.sleep(1000);
        System.out.println("测试删除功能成功");

        //测试克隆功能
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//div[@class='panel datagrid easyui-fluid']")).findElement(By.xpath("//table[@class='datagrid-btable']")).findElement(By.xpath("//tr[@id='datagrid-row-r1-2-0']")).findElement(By.xpath("//div[@class='datagrid-cell datagrid-cell-c1-action']")).findElement(By.xpath("//span[text()='克隆']")).click();
//        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//div[@class='panel datagrid easyui-fluid']")).findElement(By.xpath("//table[@class='datagrid-btable']")).findElement(By.xpath("//tr[@id='datagrid-row-r1-2-0']")).findElement(By.xpath("//td[@field='action']")).findElement(By.xpath("//span[text()='克隆']")).click();
        driver.switchTo().defaultContent();
        Thread.sleep(1000);
        System.out.println("测试克隆功能成功");

        //测试显示详情功能
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//div[@class='panel datagrid easyui-fluid']")).findElement(By.xpath("//table[@class='datagrid-btable']")).findElement(By.xpath("//tr[@id='datagrid-row-r1-2-0']")).findElement(By.xpath("//div[@class='datagrid-cell datagrid-cell-c1-action1']")).findElement(By.xpath("//span[text()='显示详情']")).click();
        driver.switchTo().defaultContent();
        Thread.sleep(1000);
        driver.findElement(By.xpath("//div[@class='panel window']")).findElement(By.xpath("//div[@class='dialog-button']")).findElement(By.xpath("//span[text()='关闭']")).click();
        System.out.println("测试显示详情功能成功");

        //测试查询功能
        WebElement webE=driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//form[@id='titleForm']"));
        webE.findElement(By.xpath("//span[@class='textbox']")).findElement(By.tagName("input")).sendKeys("文本");
        webE.findElement(By.xpath("//input[@value='设计题目']")).click();
        webE.findElement(By.xpath("//span[text()='查询']")).click();
        Thread.sleep(10000);
        driver.switchTo().defaultContent();
        System.out.println("测试查询功能成功");

        //测试查询后的清空功能
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//form[@id='titleForm']")).findElement(By.xpath("//span[text()='清空']")).click();
//        webE.findElement(By.xpath("//span[@class='textbox']")).findElement(By.tagName("input")).sendKeys("文本");
//        webE.findElement(By.xpath("//input[@value='设计题目']")).click();
//        webE.findElement(By.xpath("//span[text()='查询']")).click();
        Thread.sleep(10000);
        driver.switchTo().defaultContent();
        System.out.println("测试查询后的清空功能");

        //测试添加设计题目
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//a[@id='addDesignModel']")).click();
        driver.switchTo().defaultContent();
        WebElement webElement=driver.findElement(By.xpath("//div[@class='panel window']")).findElement(By.id("editProject"));
        webElement.findElement(By.id("title")).sendKeys("山东建筑大学");
        webElement.findElement(By.id("subTitle")).sendKeys("信管");
        Select sel=new Select(webElement.findElement(By.id("projectType.id")));
        sel.selectByValue("3");
        Select sel1=new Select(webElement.findElement(By.id("fidelity")));
        sel1.selectByValue("2");
        Select sel2=new Select(webElement.findElement(By.id("projectFromSelect")));
        sel2.selectByValue("4");
        Thread.sleep(1000);
//        用以下这种方式，无法定位select
//        webElement.findElement(By.id("projectType.id")).findElement(By.xpath("//option[@value='3']")).isSelected();
//        webElement.findElement(By.id("fidelity")).findElement(By.xpath("//option[text()=' 模拟']")).isSelected();
//        webElement.findElement(By.id("projectFromSelect")).findElement(By.xpath("//option[text()=' 生产']"));
        webElement.findElement(By.name("content")).sendKeys("恋爱观");
        webElement.findElement(By.name("basicRequirement")).sendKeys("哈哈观");
        webElement.findElement(By.name("basicSkill")).sendKeys("书费");
        webElement.findElement(By.name("reference")).sendKeys("的横幅诶");
        webElement.findElement(By.xpath("//div[@class='dialog-button']")).findElement(By.xpath("//span[text()='提交']")).click();
        System.out.println("测试添加设计题目成功");

        // 测试添加论文题目
        driver.switchTo().frame(driver.findElement(By.xpath("//iframe[@frameborder='0']"))).findElement(By.xpath("//a[@id='addPaperModel']")).click();
        driver.switchTo().defaultContent();
        WebElement webElement1=driver.findElement(By.xpath("//div[@class='panel window']")).findElement(By.id("editProject"));
        webElement1.findElement(By.id("title")).sendKeys("设计山东建筑大学");
        webElement1.findElement(By.id("subTitle")).sendKeys("设计信管");
        Select sel3=new Select(webElement1.findElement(By.name("projectType.id")));
        sel3.selectByValue("4");
        Select sel4=new Select(webElement1.findElement(By.id("fidelity")));
        sel4.selectByValue("2");
        Select sel5=new Select(webElement1.findElement(By.id("projectFromSelect")));
        sel5.selectByValue("2");
        Thread.sleep(1000);
        webElement1.findElement(By.name("content")).sendKeys("设计恋爱观");
        webElement1.findElement(By.name("basicRequirement")).sendKeys("设计哈哈观");
        webElement1.findElement(By.name("basicSkill")).sendKeys("设计书费");
        webElement1.findElement(By.name("reference")).sendKeys("设计的横幅诶");
        webElement1.findElement(By.xpath("//div[@class='dialog-button']")).findElement(By.xpath("//span[text()='提交']")).click();
        System.out.println("测试添加论文题目成功");


    }
    @AfterClass
    public void after() {
        System.out.print("******");
        driver.quit();
    }



    public static void highlight(WebDriver diver, WebElement element) {
        JavascriptExecutor js = (JavascriptExecutor) diver;
        js.executeScript("element = arguments[0];" +
                "original_style = element.getAttribute('style');" +
                "element.setAttribute('style', original_style + \";" +
                "background: yellow; border: 2px solid red;\");" +
                "setTimeout(function(){element.setAttribute('style', original_style);}, 1000);", element);
    }
}
