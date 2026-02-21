define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'usersignin/index' + location.search,
                    table: 't_user_sign_in',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [
                    [
                        {field: 'id', title: __('Id'), sortable: true},
                        {
                            field: 'uid',
                            title: '用户ID',
                            operate: '=',
                            sortable: true
                        },                     
                        {
                            field: 'account',
                            title: '昵称',
                            operate: 'LIKE'
                        },
                        {
                            field: 'day',
                            title: '签到日期',
                            operate: 'BETWEEN',
                            addclass: 'datetimerange',
                            formatter: Table.api.formatter.datetime,
                            sortable: true
                        },
                        {
                            field: 'itime',
                            title: '创建时间',
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            formatter: Table.api.formatter.datetime,
                            sortable: true
                        },
                        {
                            field: 'utime',
                            title: '更新时间',
                            operate: 'RANGE',
                            addclass: 'datetimerange',
                            formatter: Table.api.formatter.datetime,
                            sortable: true
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);
        }
    };
    return Controller;
});
