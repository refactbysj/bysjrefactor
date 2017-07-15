package com.newview.bysj.Selenium2;

/**
 * Created by apple on 17/5/20.
 */
        import org.apache.poi.xssf.usermodel.XSSFCell;
        import org.apache.poi.xssf.usermodel.XSSFRow;
        import org.apache.poi.xssf.usermodel.XSSFSheet;
        import org.apache.poi.xssf.usermodel.XSSFWorkbook;

        import javax.swing.filechooser.FileSystemView;
        import java.io.FileInputStream;
        import java.io.IOException;
        import java.io.InputStream;
        import java.util.HashMap;
        import java.util.Map;

/**
 * Created by mj on 2017/5/18.
 */
public class ImportExcel1 {
    public Map<Integer, Map<String,String>> importExcel() throws IOException{
        //创建Map集合用来存储测试的数据，Integer代表几条数据，Map<String,String>代表数据内容
        Map<Integer, Map<String,String>> workContents = new HashMap<>();
        //获取测试文件的地址（桌面）
        String url = FileSystemView.getFileSystemView().getHomeDirectory().getPath()+"/添加设计课题.xlsx";
        //创建一个输入流读取Excel文件
        InputStream inputStream = new FileInputStream(url);
        //POIFSFileSystem poifsFileSystem = new POIFSFileSystem(inputStream);
        /*
        HSSFWorkbook:是操作Excel2003以前（包括2003）的版本，扩展名是.xls
        XSSFWorkbook:是操作Excel2007的版本，扩展名是.xlsx
        */
        //得到Excel工作簿的对象
        XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
        //获取第一个工作表
        XSSFSheet sheet = workbook.getSheetAt(0);
        //获取第一行
        XSSFRow row = sheet.getRow(0);
        //用数组来储存第一行内容，即是每一列的标题（数组长度为cell的数量）
        String[] title = new String[row.getPhysicalNumberOfCells()];
        //获取每个cell的数值，baocun在title数字中
        for (int i=0;i<row.getPhysicalNumberOfCells();i++){
            //设置cell的值为String类型
            //row.getCell(i).setCellType(Cell.CELL_TYPE_STRING);
            title[i] = row.getCell(i).getStringCellValue();
        }
        //从1开始，因为数据的第一行为标题
        //获取表格数据的条数（0开始，比实际数目少1）
        for (int i=1;i<= sheet.getLastRowNum();i++){
            //获取一行
            row = sheet.getRow(i);
            //建立map集合，用来储存数据
            Map<String,String> workContent = new HashMap<>();
            //获取一行单元格的数目，循环储存在map集合
            for (int j=0;j<row.getPhysicalNumberOfCells();j++){
                //获得某个单元格
                XSSFCell cell = row.getCell(j);
                //key储存标题，value储存单元格的值
                workContent.put(title[j],cell.getStringCellValue());
            }
            //把每一个workContent放入workContents中；key为第一行，value为map集合
            workContents.put(i,workContent);
        }
        //最后返回带有测试信息的Map集合
        return workContents;

    }

}

