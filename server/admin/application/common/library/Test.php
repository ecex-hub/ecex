<?php

namespace app\common\library;

class Test
{
    // 入口方法
    public function test()
    {
        $title = self::getTitle();
        $data = self::getData();
        // 下载直接保存文件
//        self::downloadExcel($title, $data, 'download_by_file.xlsx');
        // 浏览器弹框下载
        self::downloadExcel($title, $data, 'downloadByBrowser.xlsx', 2);
    }


    public function getData()
    {
        $data = [];
        for ($i = 0; $i < 10; $i++) {
            $data[] = ['name' => "姓名{$i}", 'hobby' => "爱好{$i}"];
        }
        return $data;
    }

    public function getTitle()
    {
        return [
            'name' => '姓名',
            'hobby' => '爱好'
        ];
    }

    /**
     * 把数据下载为文件
     * @param $title 标题数据
     * @param $data  内容数据
     * @param $fileName 文件名（可包含路径）
     * @param int $type Excel 下载类型：1 - 下载文件；2 - 浏览器弹框下载
     * @param string $sheet Excel 的工作表
     */
    public function downloadExcel($title, $data, $fileName, $type = 1, $sheet = 'Sheet1')
    {
        $writer = new \XLSXWriter();

        if ($type == 2) {
            // 设置 header，用于浏览器下载
            header('Content-disposition: attachment; filename="' . \XLSXWriter::sanitize_filename($fileName) . '"');
            header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            header('Content-Transfer-Encoding: binary');
            header('Cache-Control: must-revalidate');
            header('Pragma: public');
        }

        // 处理标题数据，都设置为 string 类型
        $header = [];
        foreach ($title as $value) {
            $header[$value] = 'string'; // 把表头的数据全部设置为 string 类型
        }
        $writer->writeSheetHeader($sheet, $header);

        // 根据标题数据 title，按 title 的字段顺序把数据一条条加到 excel 中
        foreach ($data as $key => $value) {
            $row = [];
            foreach ($title as $k => $val) {
                $row[] = $value[$k];
            }
            $writer->writeSheetRow($sheet, $row);
        }

        if ($type == 1) { // 直接保存文件
            $writer->writeToFile($fileName);
        } else if ($type == 2) { // 浏览器下载文件
            $writer->writeToStdOut();
//            echo $writer->writeToString();
            exit(0);
        } else {
            die('文件下载方式错误~');
        }
    }

}