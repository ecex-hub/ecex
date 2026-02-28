define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

  var Controller = {

    // 账单通用列（index 用）
    _getCommonColumns: function () {
      return [
        [
          { checkbox: true },
          { field: 'id', title: __('Id'), operate: false },
          { field: 'user.oneLevel', title: '上级id' },
          { field: 'uid', title: __('Uid') },
          { field: 'user.nickname', title: __('Nickname') },
          { field: 'money', title: __('Money'), operate: false },
          { field: 'money_type', title: __('Money_type'), operate: false },
          { field: 'bill_unit', title: __('Bill_unit'), operate: false },
          { field: 'bill_type', title: __('Bill_type'), operate: false },
          { field: 'admin.id', title: '管理员id' },
          { field: 'admin.nickname', title: '管理员名称' },
          { field: 'ext_content', title: '备注' },
          {
            field: 'itime',
            title: __('Itime'),
            operate: false,
            addclass: 'datetimerange',
            autocomplete: false,
            formatter: Table.api.formatter.datetime
          }
        ]
      ];
    },

    // 充值页面专用列（你可以根据需要调整）
    _getRechargeColumns: function () {
      return [
        [
          { checkbox: true },
          { field: 'id', title: __('Id'), operate: false },
          { field: 'uid', title: __('Uid') },
          { field: 'user.nickname', title: __('Nickname') },
          { field: 'user.oneLevel', title: '上级id' },
          { field: 'user.upuser.nickname', title: '上级账号' },
          { field: 'money', title: '充值金额', operate: false },
          { field: 'bill_type', title: '类型', operate: false },  // 也可以去掉
          { field: 'ext_content', title: '备注' },
          {
            field: 'itime',
            title: '充值时间',
            operate: false,
            addclass: 'datetimerange',
            autocomplete: false,
            formatter: Table.api.formatter.datetime
          }
        ]
      ];
    },

    // 公共方法：初始化表格
    _initTable: function (columns) {
      var table = $("#table");

      // 初始化表格
      table.bootstrapTable({
        url: $.fn.bootstrapTable.defaults.extend.index_url,
        pk: 'id',
        sortName: 'id',
        search: false,
        columns: columns
      });

      // 为表格绑定事件
      Table.api.bindevent(table);
    },
    index: function () {
      // 初始化表格参数配置（账单列表）
      Table.api.init({
        extend: {
          index_url: 'bill/index' + location.search,
          add_url: 'bill/add',
          // edit_url: 'bill/edit',
          // del_url: 'bill/del',
          multi_url: 'bill/multi',
          import_url: 'bill/import',
          table: 'bill_record',
        }
      });

      Controller._initTable(Controller._getCommonColumns());
    },
    // 充值记录列表
    recharge: function () {
      // 初始化表格参数配置（指向 recharge 接口）
      Table.api.init({
        extend: {
          index_url: 'bill/recharge' + location.search,
          // 如需多选操作，可继续复用 multi_url 等
          multi_url: 'bill/multi',
          import_url: 'bill/import',
          table: 'bill_record',
        }
      });

      Controller._initTable(Controller._getRechargeColumns());
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
      }
    }
  };
  return Controller;
});
