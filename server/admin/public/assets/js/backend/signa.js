define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'signa/index' + location.search,
                    //add_url: 'signa/add',
                    // edit_url: 'newsignin/edit',
                    // del_url: 'newsignin/del',
                    // multi_url: 'newsignin/multi',
                    // import_url: 'newsignin/import',
                    table: 'signa',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'day',
                sortName: 'day',
                pagination: false,
                commonSearch: false,
                search: false,
                showToggle: false,
                showExport: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'uid',
                            visible: false,
                        },
                        {
                            field: 'day',
                            title: "漏签天数",
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '确定',
                                    // title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) { //row 表格接收到的数据
                                        Fast.api.ajax({
                                            url: 'signa/pass',
                                            data: {
                                                uid: row.uid,
                                                day: row.day
                                            },
                                        }, function (data, ret) {
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {

                                        });
                                    },
                                },
                            ],
                            events: Table.api.events.operate,
                            formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);

            $(document).on("click", ".btn-approve-1", function () {
                var data = table.bootstrapTable('getSelections');
                var params = [];
                for (var i = 0; i < data.length; i++) {
                    params.push({
                        uid: data[i]['uid'],   // 获取 id
                        day: data[i]['day']  // 获取 uid
                    });
                }
                Backend.api.ajax({
                    url: "signa/multipass",
                    data: {
                        params: JSON.stringify(params)  // 将数组转换为 JSON 字符串
                    }
                }, function (data, ret) {
                    table.bootstrapTable('refresh');
                    // if (ret.code === 1) {
                    // } else {
                    //     Toastr.error(ret.msg);
                    // }
                }, function (data, ret) {
                    console.log(ret);
                    Layer.close(index);
                });
            });

            parent.window.$(".layui-layer-iframe").find(".layui-layer-close").on('click', function () {
                parent.$("#table").bootstrapTable('refresh', {});
            });
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
