define(['jquery', 'bootstrap', 'backend', 'table', 'form'], function ($, undefined, Backend, Table, Form) {

    var Controller = {
        index: function () {
            // 初始化表格参数配置
            Table.api.init({
                extend: {
                    index_url: 'pay/index' + location.search,
                    add_url: 'pay/add',
                    // edit_url: 'pay/edit',
                    // del_url: 'pay/del',
                    multi_url: 'pay/multi',
                    import_url: 'pay/import',
                    table: 'pay',
                }
            });


            var table = $("#table");

            // https://ask.fastadmin.net/article/323.html
            //当表格数据加载完成时
            table.on('load-success.bs.table', function (e, data) {

                $("#buy_total").text(data.buy_total);
                $("#buy_money").text(data.buy_money);
                $("#success_rate").text(data.success_rate);

            });


            // https://ask.fastadmin.net/question/31044.html
            // 初始化表格
            table.bootstrapTable({
                url: $.fn.bootstrapTable.defaults.extend.index_url,
                pk: 'id',
                sortName: 'id',
                fixedColumns: true,
                fixedRightNumber: 1,
                visible: false,//切换卡片
                searchFormVisible: true,
                search: false,
                columns: [
                    [
                        {field: 'id', title: __('Id')},
                        {
                            field: 'itime',
                            title: __('Itime'),
                            operate: 'BETWEEN',
                            addclass: 'datetimepicker',
                            formatter: Table.api.formatter.datetime,
                            // searchList:
                            //     function (a, b) {
                            //         return '' +
                            //             '    <input type="hidden" class="form-control operate" name="itime" data-name="itime" value="" readonly="">' +
                            //             '    <div class="row">' +
                            //             '        <div class="col-xs-12">' +
                            //             '            <div class="form-inline row">' +
                            //             '                <div class="col-xs-14 col-sm-6">' +
                            //             '                    <input type="text" style="width:150px" data-rule="required" class="form-control datetimepicker" name="itime" id="s-s-time" value="" placeholder="开始日期"  data-use-current="true">' +
                            //             '                    <span>至</span>' +
                            //             '                    <input type="text" style="width:150px" data-rule="required" class="form-control datetimepicker" name="itime" id="s-e-time" value="" placeholder="结束日期"  data-use-current="true">' +
                            //             '                </div>' +
                            //             '            </div>' +
                            //             '        </div>' +
                            //             '    </div>';
                            //     },
                        },
                        {
                            field: 'otn',
                            title: __('Otn'),
                            operate: 'LIKE',
                            table: table,
                            class: 'autocontent',
                            formatter: Table.api.formatter.content
                        },
                        {
                            field: 'money',
                            title: __('Money'),
                            operate: false,
                        },
                        {
                            field: 'paytime',
                            title: __('Paytime'),
                            operate: false,
                            autocomplete: false,
                            formatter: Table.api.formatter.datetime,
                        },
                        {
                            field: 'sys.pay_mch',
                            title: '支付渠道',
                            visible: false,
                            //1-支付宝 2-微信 3-银行 4-云闪付
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="sys.pay_mch" value="" id="type1" checked="checked" /> ' +
                                        '<label>不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="sys.pay_mch" value="1" id="type2" /> ' +
                                        '<label>福海支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="sys.pay_mch" value="2" id="type3" /> ' +
                                        '<label>桥头支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="sys.pay_mch" value="3" id="type4" /> ' +
                                        '<label>alin支付</label>' +
                                        '<input type="radio" name="sys.pay_mch" value="4" id="type5" /> ' +
                                        '<label>四海</label>' +
                                        '<input type="radio" name="sys.pay_mch" value="5" id="type6" /> ' +
                                        '<label>四海云四方</label>' +
                                        '<input type="radio" name="sys.pay_mch" value="6" id="type7" /> ' +
                                        '<label>大圣支付</label>' +
                                        '<input type="radio" name="sys.pay_mch" value="7" id="type8" /> ' +
                                        '<label>PT中外支付</label>&nbsp;&nbsp;';
                                },
                        },
                        {
                            field: 'pay_chnl',
                            title: '支付渠道',
                            operate: false,
                            //1-支付宝 2-微信 3-银行 4-云闪付
                        },
                        {
                            field: 'pay_type',
                            title: "支付类型",
                            //1-支付宝 2-微信 3-银行 4-云闪付
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="pay_type" value="" id="type1" checked="checked" /> ' +
                                        '<label>不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="1" id="type2" /> ' +
                                        '<label>支付宝</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="2" id="type3" /> ' +
                                        '<label>微信</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="pay_type" value="3" id="type4" /> ' +
                                        '<label>银行</label>' +
                                        '<input type="radio" name="pay_type" value="4" id="type5" /> ' +
                                        '<label>云闪付</label>&nbsp;&nbsp;';
                                },
                        },
                        // {field: 'sys_id', title: __('Sys_id')},
                        {field: 'uid', title: __('Uid')},
                        {field: 'user.nickname', title: __('Nickname')},
                        {
                            field: 'type',
                            title: __('Type'),
                            searchList: //{"0": "男", "1": "女"},//使用这个则显示下拉列表，用下面的function则自定义单选框
                                function (a, b) {
                                    return '<input type="radio" name="type" value="" id="type" checked="checked" /> ' +
                                        '<label for="sex1">不选择</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="1" id="type2" /> ' +
                                        '<label for="sex2">待支付</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="2" id="type2" /> ' +
                                        '<label for="sex3">成功</label>&nbsp;&nbsp;' +
                                        '<input type="radio" name="type" value="3" id="type4" /> ' +
                                        '<label for="sex4">失败</label>';
                                },
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

                                        Layer.confirm("确定要同意该用户订单吗？此操作不可撤销！", {icon: 3, title: "警告"}, function (index) {
                                            // 用户确认后发送请求
                                            Fast.api.ajax({
                                                url: 'pay/pass',
                                                data: {
                                                    ids: row.id,
                                                },
                                                type: "POST",
                                            }, function (data, ret) {
                                                // 成功回调
                                                $(".btn-refresh").trigger("click");
                                            }, function (data, ret) {
                                                // 失败回调
                                                Toastr.error(ret.msg || "删除失败！");
                                            });
                                            Layer.close(index); // 关闭确认框
                                        });
                                    }
                                },
                            ],
                            events: Table.api.events.operate,
                            formatter: function (value, row, index) {
                                if (row._type == 1) {
                                    return Table.api.formatter.operate.call(this, value, row, index);
                                } else {
                                    return '';
                                }
                            }
                        }
                    ]
                ]
            });

            // 为表格绑定事件
            Table.api.bindevent(table);
            // $('#s-s-time').on('dp.change', function (e) {
            //     // e.date 是一个 moment 对象，表示选中的日期时间
            //     console.log(e)
            //     if (e.date) {
            //         var formattedDate = e.date.format('YYYY-MM-DD HH:mm:ss');
            //         console.log('新选中的时间是：', formattedDate);
            //     }
            // });
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
