define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

  var Controller = {
    index: function () {
      // 初始化表格参数配置
      Table.api.init({
        extend: {
          index_url: 'product/index' + location.search,
          add_url: 'product/add',
          edit_url: 'product/edit',
          del_url: 'product/del',
          multi_url: 'product/multi',
          import_url: 'product/import',
          table: 'product',
        }
      });

      var table = $("#table");

      // 初始化表格
      table.bootstrapTable({
        url: $.fn.bootstrapTable.defaults.extend.index_url,
        pk: 'id',
        sortName: 'id',
        fixedColumns: true,
        fixedRightNumber: 1,
        columns: [
          [
            { checkbox: true },
            { field: 'id', title: __('Id') },
            {
              field: 'name',
              title: __('Name'),
              operate: false,
              table: table,
              class: 'autocontent',
              formatter: Table.api.formatter.content
            },
            {
              field: 'image',
              title: "产品封面",
              operate: false,
              table: table,
              formatter: Controller.api.formatter.thumb
            },
            { field: 'price', title: __('Price'), operate: false },
            //{field: 'is_hot', title: __('Is_hot'), operate: false},
            { field: 'limit_num', title: __('Limit_num'), operate: false },
            { field: 'sort', title: __('Sort'), operate: false },
            { field: 'product_type_name', title: "产品类型", operate: false },
            { field: 'times', title: "返利次数", operate: false },
            { field: 'rate', title: "每次返利(%)", operate: false },
            //{ field: 'allowance', title: __('Allowance'), operate: false },
            //{ field: 'month_income', title: "每月补助", operate: false },
            { field: 'period', title: "返利周期(天):", operate: false },
            { field: 'salenum', title: "销售数量", operate: false },
            {
              field: 'itime',
              title: __('Itime'),
              operate: false,
              addclass: 'datetimerange',
              autocomplete: false,
              formatter: Table.api.formatter.datetime
            },
            // {
            //     field: 'utime',
            //     title: __('Utime'),
            //     operate: 'RANGE',
            //     addclass: 'datetimerange',
            //     autocomplete: false,
            //     formatter: Table.api.formatter.datetime
            // },
            {
              field: 'operate',
              title: __('Operate'),
              table: table,
              events: Table.api.events.operate,
              formatter: Table.api.formatter.operate
            }
          ]
        ]
      });

      // 为表格绑定事件
      Table.api.bindevent(table);
    },
	tongji: function () {
      // 初始化表格参数配置
      Table.api.init({
        extend: {
          index_url: 'product/index' + location.search,
          add_url: 'product/add',
          edit_url: 'product/edit',
          del_url: 'product/del',
          multi_url: 'product/multi',
          import_url: 'product/import',
          table: 'product',
        }
      });

      var table = $("#table");

      // 初始化表格
      table.bootstrapTable({
        url: $.fn.bootstrapTable.defaults.extend.index_url,
        pk: 'id',
        sortName: 'id',
        fixedColumns: true,
        fixedRightNumber: 1,
        columns: [
          [           
            { field: 'id', title: __('Id') },
            {
              field: 'name',
              title: __('Name'),
              operate: false,
              table: table,
              class: 'autocontent',
              formatter: Table.api.formatter.content
            },          
            { field: 'price', title: __('Price'), operate: false },            
            { field: 'product_type_name', title: "产品类型", operate: false },
			{ field: 'salenum', title: "销售数量", operate: false },
			{ field: 'buypeoplenum', title: "购买人数", operate: false },
			{ field: 'inmoney', title: "投资金额", operate: false },
			{ field: 'outmoney', title: "拨出金额", operate: false },
			{ field: 'outtimes', title: "拨出次数", operate: false }         
          ]
        ]
      });

      // 为表格绑定事件
      Table.api.bindevent(table);
    },
    add: function () {
      Controller.api.bindevent();
    },
    edit: function () {
      Controller.api.bindevent();
    },
    api: {
      bindevent: function () {
        Form.api.bindevent($("form[role=form]"));
      },
      formatter: {
        thumb: function (value, row, index) {
          var html = '';
          html = '<a href="' + row.image + '" target="_blank"><img src="' + row.image + '" alt="" style="max-height:60px;max-width:120px"></a>';
          return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
        },
        video: function (value, row, index) {
          var html = '';
          html = '<a href="' + row.video_url + '" target="_blank"><video style="max-height:60px;max-width:120px" controls> <source src="' + row.video_url + '" type="video/mp4"></video></a>';
          return `
                            <div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">
                                ${html}
                            </div>
                        `;
        }

      }
    }
  };
  return Controller;
});
