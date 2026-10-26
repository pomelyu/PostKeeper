# PostKeeper
PostKeeper 是一個明信片收藏的手機應用。明信片由使用者拍照或從手機相簿匯入，並編輯寄件與收件資訊。使用者可以在應用中瀏覽收藏的明信片
以下是他的主要特色：
1. 支援多語言的介面
2. 從手機相簿或是拍照新增明信片，並加上寄件與受件的人物、日期與地理位置
3. 明信片按照地理位置分類，並在地圖中顯示
4. 明信片按照時間排序，並提供搜尋
5. 提供完整收藏的備份和還原功能

## 技術名詞
- Collection（收藏夾）：使用者自訂，可以是任意名稱，可以刪除、重新命名或管理包含的明信片，一張明信片可以同時屬於多種收藏夾

## 主要頁面
主要頁面藉著底下的 Navigation Bar 切換。由左到右排列分別是
- MainView: 使用者進入app時的主頁面
- KeeperView: 以資料夾、收藏夾或是 List 顯示明信片
- MapView: 以地圖的方式顯示收藏的明信片
- UserView: 顯示使用者的收藏總覽、編輯使用者的個人資訊、提供 app 的各項設定

詳細的頁面功能參見`docs/views.md`

## 次要介面
次要介面從主要介面或是其他次要介面進入，均提供返回來源介面的功能
- PostcardView: 顯示明信片的正反面和寄件、收件資訊
- PostcardEditView: 提供明信片的編輯
- CollectionView: 以 Grid 的形式顯示收藏夾內的所有明信片
- ContactView: 管理聯絡人列表，可以設定人和對應的地址

詳細的頁面功能參見`docs/views.md`

## Routing
- 任何時候主要頁面都可藉著底下的 Navigation Bar 進入
- 在任何頁面，點選明信片進入該明信片的 PostcardView
- 在任何頁面，點選收藏夾或資料夾後進入 CollectionView
- 「新增」或是「修改」明信片進入 PostcardEditView
- PostcardEditView 按下「取消」或是「儲存」回到進入前的頁面
- 所有次要頁面按下「返回」回到進入前的頁面

# 資料夾與程式架構
```bash
docs/
    data_schema.md  # DB 的設計
    ui_design.md    # UI 的設計風格和準則
    views.md        # 所有 view 的詳細 spec
assets/             # UI 的資源
lib/
    data/
        models/         # 專案內使用的資料格式
        repositories/   # 提供資料操作的 API
        servies/        # 連結資料庫或是外部服務
    ui/
        core/           # 可共用的 widget
        style.dart      # app 跨 view 的 style 設定       
    enums.dart
    main.dart           # app 進入點
    router.dart         # 設定 view 的 route 和 URI
```
- 每個 View 都會拆成 stateless 的 View 和管理狀態的 ViewModel

# UI 設計
以鼠尾草綠與奶油紙色為基底，結合手帳文具、旅行明信片和白虎角色的溫暖收藏介面。參考`docs/ui_design.md`

# Tech Stack
- 使用 Dart + Flutter 開發

# Development
- 只對程式邏輯和 UI routing 作測試。禁止元件動畫、位置、顏色外觀等的測試
- 禁止利用匹配固定文字來測試。改為匹配特定大元件的 key
- 實作禁止修改不相關的程式碼，無論是否有格式不符合或是拼字錯誤。若在非實作範圍外有更佳的寫法先跳過，並在實作後告知
