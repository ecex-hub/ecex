define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'real/index' + location.search,
                    add_url: 'real/add',
                    // edit_url: 'real/edit',
                    // del_url: 'real/del',
                    multi_url: 'real/multi',
                    import_url: 'real/import',
                    table: 'real',
                }
            });

            var table = $("#table");

            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                search: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'id',
                            title: __('Id'), sortable: true
                        },
                        {
                            field: 'uid',
                            title: __('Uid')
                        },
                        {
                            field: 'user.nickname',
                            title: __('Nickname')
                        },
                        {
                            field: 'realName',
                            title: __('RealName'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {field: 'IDCard', title: __('IDCard'), operate: 'LIKE'},
                        {
                            field: 'IDOppositeUrl',
                            title: __('IDOppositeUrl'),
                            operate: false,
                            formatter: Controller.api.formatter.thumbB
                        },
                        {
                            field: 'IDFrontUrl',
                            title: __('IDFrontUrl'),
                            operate: false,
                            formatter: Controller.api.formatter.thumbA
                        },
                        {
                            field: 'type',
                            title: __('Type'),
                            operate: 'LIKE',
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="type" value="" id="type1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="1" id="type2" /> ' +
                                        '<label for="sex2">默认</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="2" id="type3" /> ' +
                                        '<label for="sex3">通过</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="3" id="type4" /> ' +
                                        '<label for="sex4">拒绝</label>';
                                },

                        },
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: false,
                            addclass: 'datetimerange',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'operate',
                            title: __('Operate'),
                            table: table,
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '通过',
                                    title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'real/pass',
                                            data: {
                                                ids: row.id,
                                            }
                                        }, function (data, ret) {
                                            //成功的回调
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {
                                            //失败的回调
                                        });
                                    }
                                },
                                {
                                    name: 'detail',
                                    text: '拒绝',
                                    title: '拒绝',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'real/nopass',
                                            data: {
                                                ids: row.id,
                                            }
                                        }, function (data, ret) {
                                            $(".btn-refresh").trigger("click");
                                        }, function (data, ret) {

                                        });
                                    }
                                }
                            ],
                            events: Table.api.events.operate,
                            formatter: function (value, row, index) {
                                if (row._type != 1) {
                                    return "";
                                } else {
                                    return Table.api.formatter.operate.call(this, value, row, index);
                                }
                            }
                            // formatter: Table.api.formatter.operate
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);


            $(document).on("click", ".btn-approve-1", function () {
                var data = table.bootstrapTable('getSelections');
                var ids = [];
                for (var i = 0; i < data.length; i++) {
                    ids[i] = data[i]['id'];
                }
                console.log(ids)
                Backend.api.ajax({
                    url: "real/multipass",
                    data: {ids: ids}
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

            $(document).on("click", ".btn-approve-2", function () {
                var data = table.bootstrapTable('getSelections');
                var ids = [];
                for (var i = 0; i < data.length; i++) {
                    ids[i] = data[i]['id'];
                }
                console.log(ids)
                Backend.api.ajax({
                    url: "real/multinopass",
                    data: {ids: ids}
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
                thumbA: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.IDFrontUrl + '" target="_blank"><img src="' + row.IDFrontUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
                thumbB: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.IDOppositeUrl + '" target="_blank"><img src="' + row.IDOppositeUrl + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                },
            }
        }
    };
    return Controller;
});
