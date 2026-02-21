define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'newsignin/index' + location.search,
                    add_url: 'newsignin/add',
                    // edit_url: 'newsignin/edit',
                    // del_url: 'newsignin/del',
                    multi_url: 'newsignin/multi',
                    import_url: 'newsignin/import',
                    table: 'newsignin',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'uid',
                sortName: 'uid',
                search: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'uid', title: "用户id"
                        },
                        {
                            field: 'nickname',
                            title: "用户名称",
                            operate: "like",
                        },
                        {
                            field: 'red_count',
                            title: "剩余指定红包个数",
                            operate: false,
                        },
                        {
                            field: 'normal_red_count',
                            title: "剩余普通红包个数",
                            operate: false,
                        },
                        {
                            field: 'sign_in_num',
                            title: "连续签到天数",
                            operate: false,
                        },
                        {
                            field: 'diff_day',
                            title: "漏签天数",
                            operate: false,
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '已签',
                                    // title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-success btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'signb/index?uid=' + row.uid;
                                    },
                                },
                                {
                                    name: 'detail',
                                    text: '补签',
                                    // title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'signa/index?uid=' + row.uid;
                                    },
                                    // callback: function (data) {
                                    //     //回调方法，用来响应 Fast.api.close()方法 **注意不能有success 是btn-ajax的回调，btn-dialog 用的callback回调，两者不能同存！！！！
                                    //     $(".btn-refresh").trigger("click");//刷新当前页面的数据
                                    // },
                                },
                            ],
                            events: Table.api.events.operate,
                            formatter: function (value, row, index) {
                                if (row.diff_day == 0) {
                                    return '<a href="signb/index?uid=' + row.uid + '" ' +
                                        'class="btn btn-xs btn-success btn-dialog" ' +
                                        '>已签</a>';
                                } else {
                                    return Table.api.formatter.operate.call(this, value, row, index);
                                }
                            },
                        }
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
            }
        }
    };
    return Controller;
});
