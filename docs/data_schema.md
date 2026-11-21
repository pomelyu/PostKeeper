# 資料庫 Schema

此文件為第一版設計，採用本機 SQLite 與圖片檔案並存的 hybrid 架構；資料庫儲存結構化資料及圖片相對路徑，圖片本體存放於 App 的持久化資料目錄，不寫入資料庫。

## 共通格式

- 欄位名稱採 `snake_case`；`PK` 為主鍵、`FK` 為外鍵，除標示 `NULL` 外皆為 `NOT NULL`。
- ID 使用 `TEXT`，新資料由 App 產生 UUID，既有固定 ID 保留為字串。
- 建立與更新時間使用 `INTEGER`，格式為 UTC Unix epoch milliseconds，對應 Dart `DateTime`。
- 寄件與收件日期使用 `TEXT`，格式為 `YYYY-MM-DD`，代表日曆日期，不進行時區換算。
- 布林值使用 `INTEGER`，以 `CHECK` 限制為 `0` 或 `1`。
- 外鍵寫入與刪除皆須啟用 SQLite foreign key 檢查。

## 1. `persons`：人物

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `id` | `TEXT / PK` | 人物的唯一識別碼。 |
| `name` | `TEXT` | 人物的顯示名稱，允許不同人物同名。 |
| `created_at` | `INTEGER / UTC epoch ms` | 人物資料的建立時間。 |
| `updated_at` | `INTEGER / UTC epoch ms` | 人物資料最後更新的時間。 |

目前使用者以現有 `myId` 常數的值 `me-id` 建立人物資料，供 `getMyInfo()` 與寄出、收到明信片的判斷使用；此筆資料不可刪除。

## 2. `locations`：地點

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `id` | `TEXT / PK` | 本機地點紀錄的唯一識別碼。 |
| `google_place_id` | `TEXT / NULL` | 此地點對應的 Google Place ID，手動新增或無對應資料時為 `NULL`。 |
| `name` | `TEXT` | 地點的顯示名稱。 |
| `country_code` | `TEXT / NULL / ISO 3166-1 alpha-2` | 以兩個大寫英文字母儲存國家代碼，未知時為 `NULL`。 |
| `address` | `TEXT / NULL` | 地點的完整地址。 |
| `latitude` | `REAL / NULL / -90 至 90` | 地點的 WGS84 緯度。 |
| `longitude` | `REAL / NULL / -180 至 180` | 地點的 WGS84 經度。 |
| `created_at` | `INTEGER / UTC epoch ms` | 地點紀錄的建立時間。 |
| `updated_at` | `INTEGER / UTC epoch ms` | 地點紀錄最後更新的時間。 |

經緯度須以 `CHECK` 保證同時存在或同時為 `NULL`，並限制有效範圍；國家代碼須為兩個大寫英文字母或 `NULL`。

本機 `id` 不直接使用 Google Place ID：同一外部地點可有不同的地址紀錄，且資料可獨立於外部服務保存；地區代碼由 `CountryCode` 對照表推導，不另外儲存。

`google_place_id` 不設定 `UNIQUE`，允許不同本機地址紀錄對應同一個 Google 地點。

## 3. `person_locations`：人物與地址關聯

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `person_id` | `TEXT / PK（複合）/ FK → persons.id` | 此地址所屬的人物。 |
| `location_id` | `TEXT / PK（複合）/ FK → locations.id` | 人物地址清單中的地點。 |
| `sort_order` | `INTEGER / >= 0 / DEFAULT 0` | 地址在人物清單中的顯示順序。 |

主鍵為 `(person_id, location_id)`，防止重複加入同一地址；查詢依 `sort_order, location_id` 排序，人物或未被使用的地點刪除時以 `ON DELETE CASCADE` 移除關聯。

人物與地點為多對多關係，因此多位聯絡人可共用地址；明信片的寄收件地點獨立引用 `locations`，不要求仍存在於人物目前的地址清單。

## 4. `postcards`：明信片

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `id` | `TEXT / PK` | 明信片的唯一識別碼。 |
| `title` | `TEXT / NULL` | 使用者設定的明信片標題。 |
| `orientation` | `TEXT / portrait 或 landscape` | 明信片的直式或橫式顯示方向。 |
| `front_image_path` | `TEXT / NULL / 相對檔案路徑` | 正面照片相對於 App 持久化資料根目錄的路徑。 |
| `back_image_path` | `TEXT / NULL / 相對檔案路徑` | 背面照片相對於 App 持久化資料根目錄的路徑。 |
| `sender_id` | `TEXT / NULL / FK → persons.id` | 寄件人物，尚未填寫時為 `NULL`。 |
| `recipient_id` | `TEXT / NULL / FK → persons.id` | 收件人物，尚未填寫時為 `NULL`。 |
| `send_from_id` | `TEXT / NULL / FK → locations.id` | 寄件地點，尚未填寫時為 `NULL`。 |
| `send_to_id` | `TEXT / NULL / FK → locations.id` | 收件地點，尚未填寫時為 `NULL`。 |
| `sent_at` | `TEXT / NULL / YYYY-MM-DD` | 明信片的寄出日期。 |
| `received_at` | `TEXT / NULL / YYYY-MM-DD` | 明信片的收到日期。 |
| `notes` | `TEXT / DEFAULT ''` | 使用者填寫的明信片備註。 |
| `is_favorite` | `INTEGER / 0 或 1 / DEFAULT 0` | 是否加入最愛。 |
| `created_at` | `INTEGER / UTC epoch ms` | 明信片加入收藏的時間。 |
| `updated_at` | `INTEGER / UTC epoch ms` | 明信片資料或照片最後更新的時間。 |

`orientation` 與 `is_favorite` 須設定對應的 `CHECK` 約束；兩面照片可個別缺少，但已儲存的明信片須至少有一個非空圖片路徑，以 `CHECK` 約束。

人物與地點外鍵採 `ON DELETE RESTRICT`，避免刪除聯絡人或地址時破壞既有明信片；若地址已被明信片引用，修改人物地址時建立新地點並替換 `person_locations` 關聯，保留明信片原有地點。

人物名稱採共用資料，重新命名會反映於引用該人物的明信片；修改單張明信片的地點則替換該筆外鍵，不直接覆寫其他明信片共用的地點。

## 5. `collections`：自訂收藏夾

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `id` | `TEXT / PK` | 自訂收藏夾的唯一識別碼。 |
| `name` | `TEXT` | 使用者設定的收藏夾名稱。 |
| `created_at` | `INTEGER / UTC epoch ms` | 收藏夾的建立時間。 |
| `updated_at` | `INTEGER / UTC epoch ms` | 收藏夾名稱或成員最後更新的時間。 |

此表只儲存 `CollectionType.custom`，名稱去除首尾空白後不可為空，但不限制同名。

## 6. `collection_postcards`：收藏夾與明信片關聯

| 欄位名稱 | Format | 說明 |
| --- | --- | --- |
| `collection_id` | `TEXT / PK（複合）/ FK → collections.id` | 明信片所加入的自訂收藏夾。 |
| `postcard_id` | `TEXT / PK（複合）/ FK → postcards.id` | 收藏夾內的一張明信片。 |

主鍵為 `(collection_id, postcard_id)`，防止同一明信片重複加入同一收藏夾；兩個外鍵皆採 `ON DELETE CASCADE`，刪除收藏夾只移除關聯，不刪除明信片。

## 查詢與索引

- 「全部」「最愛」「我寄出」「我收到」由 `postcards` 查詢產生，不建立額外收藏夾資料。
- 年份資料夾由 `sent_at` 推導，地區資料夾由寄件地點的國家代碼推導，缺少資料時使用現有的 `000` 分組。
- 最新寄出與收到資料分別依 `sent_at DESC, id` 與 `received_at DESC, id` 排序，排除該日期為 `NULL` 的紀錄。
- 建立 `postcards(sender_id, sent_at)`、`postcards(recipient_id, received_at)`、`postcards(sent_at)`、`postcards(created_at)` 與 `postcards(is_favorite)` 索引，支援人物、時間與最愛查詢。
- 建立 `postcards(send_from_id)`、`postcards(send_to_id)` 與 `locations(country_code)` 索引，支援地點關聯及國家篩選。
- 建立 `person_locations(location_id)` 與 `collection_postcards(postcard_id)` 索引，支援複合主鍵反向查詢與刪除檢查。
- 初版搜尋查詢明信片標題、備註及關聯人物、地點的文字欄位，不額外建立搜尋資料表。

## 圖片檔案與資料庫協作

圖片目錄範例：

```text
<App 持久化資料根目錄>/
  postkeeper.sqlite
  images/
    postcards/
      <postcard-id>/
        <image-id>.jpg
```

資料庫儲存的路徑範例為 `images/postcards/<postcard-id>/<image-id>.jpg`；副檔名須符合實際編碼，圖片不得放在 cache 或直接引用相簿、相機的暫存路徑。

- 匯入時先複製或轉碼到受 App 管理的目錄，每次新增或替換圖片使用新的檔名，避免覆寫目前仍被引用的檔案。
- 儲存時先完成新圖片寫入，再以資料庫 transaction 更新明信片與關聯；交易失敗時清除本次新建且未被引用的圖片。
- 替換或刪除照片時，待資料庫 transaction 成功後才刪除不再被引用的舊檔案。
- 檔案系統與 SQLite 無法共用同一個 transaction，因此啟動或維護時需清理中斷操作留下的孤立圖片，並保護正在匯入的檔案。
- 圖片遺失時保留明信片資料並顯示缺圖狀態，不自動刪除資料；預設圖片為 App asset，不寫入圖片路徑欄位。
- 相對路徑不得包含 `..`、絕對路徑或外部 URI，讀取時由檔案服務組合當次安裝的資料根目錄。

## 備份、還原與模型映射

- 完整備份包含一致的 SQLite 快照及所有被引用的圖片，備份期間暫停資料與圖片異動，並透過 SQLite 備份機制取得快照或關閉連線後複製，避免僅複製主檔而遺漏 WAL 資料。
- 備份包保留圖片相對目錄，並以 manifest 記錄 schema 版本、備份格式版本及圖片清單與 SHA-256，供還原前檢查完整性。
- 初版還原採整份替換，在暫存目錄驗證 schema、外鍵、圖片與路徑後，關閉資料庫並切換整份資料目錄，保留舊資料至新資料可成功開啟。
- Schema 版本使用 SQLite `PRAGMA user_version` 管理，第一版為 `1`，不額外建立版本資料表。
- DB 的空人物、空地點與空圖片使用 `NULL`；現有模型的 `dummyPerson`、`dummyLocation` 與空路徑由 Repository 映射，不建立假的人物或地點紀錄。
- `sent_at`、`received_at` 讀取為 Dart 日曆日期，`created_at`、`updated_at` 讀取為 UTC `DateTime`，由 UI 決定顯示時區。
- 本版不儲存未完成的編輯草稿；語言設定與首頁釘選設定不納入上述六張核心資料表。
