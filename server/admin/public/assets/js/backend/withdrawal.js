define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'withdrawal/index' + location.search,
                    add_url: 'withdrawal/add',
                    // edit_url: 'withdrawal/edit',
                    // del_url: 'withdrawal/del',
                    multi_url: 'withdrawal/multi',
                    import_url: 'withdrawal/import',
                    table: 'withdrawal',
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
                search: false,
                columns: [
                    [
                        {checkbox: true},
                        {
                            field: 'id',
                            title: __('Id'),
                            operate: false,
                        },
                        {field: 'uid', title: __('Uid')},
                        {
                            operate: 'LIKE',
                            field: 'user.nickname',
                            title: __('Nickname'),
                        },
                        {
                            operate: 'LIKE',
                            field: 'admin.id',
                            title: "管理员id",
                        },
                        {
                            operate: 'LIKE',
                            field: 'admin.nickname',
                            title: "管理员名称",
                        },
                        {
                            field: 'otn',
                            title: __('Otn'),
                            operate: 'LIKE'
                        },
                        {field: 'money', title: __('Money'), operate: false},
                        // {field: 'card_id', title: __('Card_id')},
                        {
                            field: 'type',
                            title: __('Type'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="type" value="" id="type1" checked="checked" /> ' +
                                        '<label for="sex1">未选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="1" id="type2" /> ' +
                                        '<label for="sex2">待审核</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="2" id="type3" /> ' +
                                        '<label for="sex3">已通过</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="3" id="type4" /> ' +
                                        '<label for="sex4">已拒绝</label>&nbsp;&nbsp;';
                                    ;
                                },
                        },
                        {field: 'content', title: "备注", operate: false},
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: false,
                            addclass: 'datetimepicker',
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        // {field: 'utime', title: __('Utime'), operate:'RANGE', addclass:'datetimerange', autocomplete:false, formatter: Table.api.formatter.datetime},
                        {
                            field: 'pay_time',
                            title: __('Pay_time'),
                            operate: 'BETWEEN',
                            addclass: 'datetimepicker',
                            // autocomplete: false,
                            formatter: Table.api.formatter.datetime
                        },
                        {
                            field: 'pay_type',
                            title: __('Pay_type'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="pay_type" value="" id="pay_type1" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="1" id="pay_type2" /> ' +
                                        '<label for="sex2">支付宝</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="3" id="pay_type4" /> ' +
                                        '<label for="sex4">银行</label>';
                                },
                        },
                        {
                            field: 'realName',
                            title: __('RealName'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content,

                        },
                        {
                            field: 'bankName',
                            title: __('BankName'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'bankCard',
                            title: __('BankCard'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        // {
                        //     field: 'subBranchName',
                        //     title: __('SubBranchName'),
                        //     operate: false,
                        //     table: table,
                        //     class: 'autocontent',
                        //     formatter: Table.api.formatter.content
                        // },
                        {
                            field: 'alipay_card',
                            title: __('Alipay_card'),
                            operate: false,
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
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
                                            url: 'withdrawal/pass',
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
                                    classname: 'btn btn-xs btn-primary btn-dialog',
                                    url: function (row, ths) { //row 表格接收到的数据
                                        return 'withdrawal/nopass/ids/' + row.id;
                                    },
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

            $(document).on("click", ".btn-export", function () {
                var options = table.bootstrapTable('getOptions');
                var search = options.queryParams({});
                var filter = search.filter;
                var op = search.op;
                var url = $(this).attr('data-url');
                location.href = url + '?filter=' + filter + '&op=' + op;
            });

            $(document).on("click", ".btn-approve-1", function () {
                var data = table.bootstrapTable('getSelections');
                var ids = [];
                for (var i = 0; i < data.length; i++) {
                    ids[i] = data[i]['id'];
                }
                console.log(ids)
                Backend.api.ajax({
                    url: "withdrawal/multipass",
                    data: {ids: ids}
                }, function (data, ret) {
                    table.bootstrapTable('refresh');
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
                // 弹出输入框，收集拒绝理由
                Layer.prompt({
                    title: '请输入拒绝理由',
                    formType: 2,  // 多行文本输入框
                    area: ['400px', '200px'],  // 设置弹窗大小
                }, function (reason, index) {
                    if (!reason) {
                        Toastr.warning("请填写拒绝理由！");
                        return;
                    }
                    Layer.close(index);  // 关闭输入框
                    // 发送 AJAX 请求
                    Backend.api.ajax({
                        url: "withdrawal/multinopass",
                        data: {
                            ids: ids,
                            reason: reason  // 将用户输入的理由传递到后端
                        }
                    }, function (data, ret) {
                        table.bootstrapTable('refresh');
                        Toastr.success("操作成功！");
                    }, function (data, ret) {
                        console.log(ret);
                        Toastr.error(ret.msg || "操作失败！");
                    });
                });
            });
        },
        add: function () {
            Controller.api.bindevent();
        },
        edit: function () {
            Controller.api.bindevent();
        },
        nopass: function () {
            Controller.api.bindevent();
        },
        multipass: function () {
            Controller.api.bindevent();
        },
        multinopass: function () {
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
