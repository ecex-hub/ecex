import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import pinia from './stores'
import {
  Button,
  Icon,
  Image,
  Grid,
  GridItem,
  Field,
  CellGroup,
  NavBar,
  Radio,
  RadioGroup,
  Popup,
  Tag
} from 'vant'
import 'vant/lib/index.css'
import './styles/main.css'

const app = createApp(App)
app.use(pinia)
app.use(router)

// 注册 Vant 组件
app.use(Button)
app.use(Icon)
app.use(Image)
app.use(Grid)
app.use(GridItem)
app.use(Field)
app.use(CellGroup)
app.use(NavBar)
app.use(Radio)
app.use(RadioGroup)
app.use(Popup)
app.use(Tag)

app.mount('#app')
