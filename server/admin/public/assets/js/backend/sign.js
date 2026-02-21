define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'sign/index' + location.search,
                    add_url: 'sign/add',
                    //edit_url: 'sign/edit',
                    //del_url: 'sign/del',
                    multi_url: 'sign/multi',
                    import_url: 'sign/import',
                    table: 'sign_in_record',
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
                        {checkbox: true},
                        {
                            field: 'id',
                            title: __('Id'),
                            operate: false,
                        },
                        {
                            field: 'uid',
                            title: __('Uid'),
                        },
                        {
                            field: 'user.nickname',
                            title: __('Nickname'),
                            operate: 'LIKE',
                        },
                        {
                            field: 'user.account',
                            title: __('Account'),
                            operate: 'LIKE',
                        },
                        {
                            field: 'continuousDay',
                            title: __('ContinuousDay'),
                            operate: false,
                        },
                        {
                            field: 'img',
                            title: __('Img'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Controller.api.formatter.thumb
                        },
                        // {
                        //     field: 'dateDay',
                        //     title: __('DateDay'),
                        //     operate: 'RANGE',
                        //     addclass: 'datetimerange',
                        //     autocomplete: false
                        // },
                        // {field: 'rewardType', title: __('RewardType')},
                        // {field: 'rewardNumber', title: __('RewardNumber')},
                        // {field: 'signInType', title: __('SignInType')},
                        {
                            field: 'type',
                            title: __('Type'),
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
                            buttons: [
                                {
                                    name: 'detail',
                                    text: '通过',
                                    title: '通过',
                                    //icon: 'fa fa-list',
                                    classname: 'btn btn-xs btn-primary btn-click',
                                    click: function (ths, row) {
                                        Fast.api.ajax({
                                            url: 'sign/pass',
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
                                            url: 'sign/nopass',
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
                    url: "sign/multipass",
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
                    url: "sign/multinopass",
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
                thumb: function (value, row, index) {
                    var html = '';
                    html = '<a href="' + row.img + '" target="_blank"><img src="' + row.img + '" alt="" style="max-height:60px;max-width:120px"></a>';
                    return '<div style="width:120px;margin:0 auto;text-align:center;overflow:hidden;white-space: nowrap;text-overflow: ellipsis;">' + html + '</div>';
                }
            }
        }
    };
    return Controller;
});
