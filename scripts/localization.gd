class_name GameLocalization
extends RefCounted

const SUPPORTED := ["zh", "en", "ms"]
const LANGUAGE_NAMES := {
	"zh": "中文",
	"en": "English",
	"ms": "Bahasa Melayu",
}

# Chinese is the authored source text. Each entry stores [English, Malay].
const STRINGS := {
	"语言 / LANGUAGE": ["LANGUAGE", "BAHASA"],
	"香兰港 · TANJONG SERAI": ["TANJONG SERAI", "TANJONG SERAI"],
	"THE LAST LABEL\n最后的展签": ["THE LAST LABEL", "THE LAST LABEL\nLABEL TERAKHIR"],
	"一段发生在虚构海峡祖屋梁宅的档案恐怖故事": ["An archival horror story set in the fictional Leong House", "Kisah seram arkib di Rumah Leong yang rekaan"],
	"开始参观": ["Begin Visit", "Mulakan Lawatan"],
	"退出": ["Quit", "Keluar"],
	"继续": ["Continue", "Teruskan"],
	"退出游戏": ["Quit Game", "Keluar Permainan"],
	"重新开始": ["Restart", "Mula Semula"],
	"单击画面继续": ["Click to continue", "Klik untuk teruskan"],
	"序章": ["Prologue", "Prolog"],
	"抵达梁宅": ["Reach Leong House", "Tiba di Rumah Leong"],
	"序章 · 雨中的梁宅": ["Prologue · Leong House in the Rain", "Prolog · Rumah Leong Dalam Hujan"],
	"进入梁宅前厅": ["Enter the front hall", "Masuk ke dewan hadapan"],
	"香兰港，下午四点十七分": ["Tanjong Serai, 4:17 PM", "Tanjong Serai, 4:17 petang"],
	"许安宁跟着旅行团来到[b]梁氏峇峇娘惹祖宅博物馆[/b]。雨落在骑楼外，纪念品店正在播放轻快的导览音乐。": ["Xu Anning follows her tour group into the [b]Leong Peranakan Ancestral House Museum[/b]. Rain falls beyond the covered walkway while cheerful tour music plays in the gift shop.", "Xu Anning mengikuti rombongannya ke [b]Muzium Rumah Pusaka Peranakan Leong[/b]. Hujan turun di luar kaki lima sementara muzik lawatan yang ceria bermain di kedai cenderamata."],
	"领取手机导览任务": ["Accept the mobile tour task", "Terima tugasan panduan telefon"],
	"梁宅导览 App": ["Leong House Guide App", "Aplikasi Panduan Rumah Leong"],
	"梁宅导览": ["LEONG HOUSE GUIDE", "PANDUAN RUMAH LEONG"],
	"今日任务：进入前厅，扫描五件展品。\n\n身后有游客在讨论晚餐，小孩踩着彩砖跑过。这里暂时只是一个普通博物馆。": ["Today's task: enter the front hall and scan five exhibits.\n\nTourists behind you discuss dinner. A child runs across the patterned tiles. For now, this is only an ordinary museum.", "Tugasan hari ini: masuk ke dewan hadapan dan imbas lima bahan pameran.\n\nPelawat di belakang berbual tentang makan malam. Seorang kanak-kanak berlari di atas jubin bercorak. Buat masa ini, ini cuma muzium biasa."],
	"梁宅导览已连接 · 展品任务 0/5": ["Guide connected · Exhibit task 0/5", "Panduan disambungkan · Tugasan pameran 0/5"],

	"第一关 · 消失的旅行团": ["Chapter 1 · The Vanishing Tour Group", "Bab 1 · Rombongan Yang Menghilang"],
	"按导览 App 扫描五件展品": ["Scan five exhibits with the guide app", "Imbas lima bahan pameran dengan aplikasi panduan"],
	"梁宅前厅": ["Leong House Front Hall", "Dewan Hadapan Rumah Leong"],
	"黑木家具沿墙排开，彩色地砖一直通向后方天井。导览员让大家自由参观十分钟。": ["Blackwood furniture lines the walls, and patterned tiles lead to the rear courtyard. The guide gives everyone ten minutes to explore.", "Perabot kayu hitam tersusun di sepanjang dinding, dan jubin bercorak menuju ke telaga udara di belakang. Pemandu memberi semua orang sepuluh minit untuk melihat-lihat."],
	"开始扫描": ["Start scanning", "Mula mengimbas"],
	"刮坏的梁氏家族合照": ["Defaced Leong family photograph", "Foto keluarga Leong yang dicakar"],
	"青花盖罐": ["Blue-and-white covered jar", "Balang bertutup biru-putih"],
	"黑木太师椅": ["Blackwood armchair", "Kerusi berlengan kayu hitam"],
	"停在 19:19 的座钟": ["Grandfather clock stopped at 19:19", "Jam besar yang terhenti pada 19:19"],
	"新嘉坡来信": ["Letter from Singapore", "Surat dari Singapura"],
	"照片中梁月澄站在左侧。她的脸上有反复刮擦的痕迹，展签却只列了四位家属。": ["Liang Yuecheng stands on the left. Her face has been scratched out repeatedly, yet the label lists only four family members.", "Liang Yuecheng berdiri di sebelah kiri. Wajahnya dicakar berkali-kali, namun label hanya menyenaraikan empat ahli keluarga."],
	"盖罐底部写着 1919。耳边传来瓷器轻碰声，但柜门没有动。": ["1919 is written beneath the jar. Porcelain chimes beside your ear, but the cabinet door never moves.", "Angka 1919 tertulis di bawah balang. Bunyi porselin berdenting di sisi telinga, tetapi pintu almari tidak bergerak."],
	"椅背内侧刻着一个很浅的‘澄’字。刚才坐在旁边的游客已经不见了。": ["A faint character for 'Cheng' is carved inside the chair back. The tourist who sat beside it is gone.", "Aksara 'Cheng' terukir samar di belakang kerusi. Pelawat yang duduk di sebelahnya tadi sudah hilang."],
	"座钟停在 19:19。秒针却在你靠近时倒走了七格。": ["The clock is stopped at 19:19. As you approach, its second hand retreats seven marks.", "Jam terhenti pada 19:19. Apabila anda menghampiri, jarum saatnya berundur tujuh tanda."],
	"信封写着 ‘Singapore, Straits Settlements’。内容提到梁瑞廷将在家宴后重签遗嘱。": ["The envelope reads 'Singapore, Straits Settlements'. The letter says Liang Ruiting will sign a new will after the family dinner.", "Sampul itu bertulis 'Singapore, Straits Settlements'. Surat menyatakan Liang Ruiting akan menandatangani wasiat baharu selepas jamuan keluarga."],
	"继续扫描": ["Continue scanning", "Teruskan imbasan"],
	"抬头看向合照": ["Look up at the photograph", "Pandang foto keluarga"],
	"刮坏的家族照片": ["Defaced family photograph", "Foto keluarga yang dicakar"],
	"穿过前厅，进入下雨的天井": ["Cross the hall into the rain-filled courtyard", "Lintasi dewan menuju telaga udara yang dihujani"],
	"第七位游客": ["The Seventh Visitor", "Pelawat Ketujuh"],
	"前厅里只剩雨声。合照中的人一个接一个消失，最后只剩梁月澄直视着镜头。\n\n手机自动弹出一句：\n[b]“第七位游客，请回到你的展柜。”[/b]": ["Only rain remains in the hall. One by one, the people vanish from the photograph until only Liang Yuecheng stares into the camera.\n\nYour phone displays a message by itself:\n[b]“Seventh visitor, please return to your display case.”[/b]", "Hanya bunyi hujan tinggal di dewan. Seorang demi seorang lenyap dari foto sehingga hanya Liang Yuecheng merenung kamera.\n\nTelefon anda memaparkan mesej dengan sendiri:\n[b]“Pelawat ketujuh, sila kembali ke kotak pameran anda.”[/b]"],
	"离开照片": ["Step away from the photograph", "Berundur dari foto"],
	"异常档案已保存 · 梁月澄（资料缺失）": ["Anomalous file saved · Liang Yuecheng (records missing)", "Fail anomali disimpan · Liang Yuecheng (rekod hilang)"],
	"导览任务尚未完成，天井门禁没有响应。": ["The tour task is incomplete. The courtyard lock does not respond.", "Tugasan lawatan belum selesai. Kunci telaga udara tidak bertindak balas."],

	"天井": ["Courtyard", "Telaga Udara"],
	"进入珠绣房，调查梁月澄留下的图案": ["Enter the beadwork room and investigate Liang Yuecheng's motifs", "Masuk ke bilik sulaman manik dan siasat motif Liang Yuecheng"],
	"雨从敞开的屋面落进井中。木楼梯通向没有灯的二层，左右门楣分别写着“珠绣房”和“厨房”。": ["Rain falls through the open roof into the well. A wooden staircase climbs toward a dark upper floor. The doorways are marked 'Beadwork Room' and 'Kitchen'.", "Hujan turun melalui bumbung terbuka ke dalam perigi. Tangga kayu menuju ke tingkat atas yang gelap. Ambang pintu bertulis 'Bilik Sulaman Manik' dan 'Dapur'."],
	"走进雨里": ["Step into the rain", "Melangkah ke dalam hujan"],
	"第二关 · 未完成的鞋": ["Chapter 2 · The Unfinished Shoe", "Bab 2 · Kasut Yang Belum Siap"],
	"查看凤凰、牡丹、蝴蝶与石榴珠样": ["Examine the phoenix, peony, butterfly and pomegranate motifs", "Periksa motif feniks, peoni, rama-rama dan delima"],
	"珠绣房": ["Beadwork Room", "Bilik Sulaman Manik"],
	"梳妆镜蒙着灰，未完成的珠绣鞋放在桌中央。四枚珠样像一套被拆开的账册索引。": ["Dust covers the vanity mirror. An unfinished beaded shoe rests at the centre of the table. Four motifs resemble an index torn from a ledger.", "Cermin meja solek diselaputi debu. Sebelah kasut manik yang belum siap terletak di tengah meja. Empat motif menyerupai indeks buku akaun yang dipisahkan."],
	"调查图案": ["Investigate the motifs", "Siasat motif"],
	"凤凰珠样": ["Phoenix motif", "Motif feniks"],
	"牡丹珠样": ["Peony motif", "Motif peoni"],
	"蝴蝶珠样": ["Butterfly motif", "Motif rama-rama"],
	"石榴珠样": ["Pomegranate motif", "Motif delima"],
	"梁月澄把账册线索藏进回首凤凰的尾羽。": ["Liang Yuecheng hid a ledger clue in the tail feathers of the backward-looking phoenix.", "Liang Yuecheng menyembunyikan petunjuk buku akaun pada bulu ekor feniks yang menoleh ke belakang."],
	"何美珠常坐在牡丹纹靠背旁，也最清楚家宴碗碟的位置。": ["He Meizhu often sat beside the peony-patterned chair and knew the dinner settings best.", "He Meizhu sering duduk di sisi kerusi bercorak peoni dan paling mengetahui susunan mangkuk jamuan."],
	"账房陈有德用‘蝴蝶过账’把数字从家账移到货账。": ["The clerk Chen Youde used a 'butterfly transfer' to move figures from the household ledger to the shipping ledger.", "Kerani Chen Youde menggunakan 'pindahan rama-rama' untuk memindahkan angka daripada buku rumah ke buku penghantaran."],
	"梁启文是唯一男嗣，石榴代表他认定属于自己的继承。": ["Liang Qiwen was the only male heir. The pomegranate marks the inheritance he believed belonged to him.", "Liang Qiwen ialah satu-satunya waris lelaki. Delima menandakan pusaka yang dianggap miliknya."],
	"记住图案": ["Remember the motif", "Ingat motif"],
	"继续查看其他图案": ["Examine another motif", "Periksa motif lain"],
	"检查桌上的未完成珠绣鞋": ["Inspect the unfinished beaded shoe", "Periksa kasut manik yang belum siap"],
	"图案吻合": ["The motifs align", "Motif sepadan"],
	"石榴的继承、蝴蝶的过账、凤凰的查账、牡丹的换碗，在鞋面拼成一条完整证词。": ["The pomegranate's inheritance, the butterfly's transfer, the phoenix's audit and the peony's switched bowl form a complete testimony across the shoe.", "Pusaka delima, pindahan rama-rama, semakan feniks dan pertukaran mangkuk peoni membentuk satu keterangan lengkap pada kasut."],
	"检查珠绣鞋": ["Inspect the beaded shoe", "Periksa kasut manik"],
	"珠线散开": ["The bead thread unravels", "Benang manik terurai"],
	"选择顺序不对。鞋面边缘的针脚提示：先是继承，再是转账，随后查账，最后有人换了碗。": ["The order is wrong. The stitches suggest: inheritance, transfer, audit, then someone switches a bowl.", "Susunannya salah. Jahitan memberi petunjuk: pusaka, pindahan, semakan, kemudian seseorang menukar mangkuk."],
	"重新排列": ["Try the sequence again", "Susun semula"],
	"按事件顺序触碰四枚珠样": ["Touch the four motifs in the order of events", "Sentuh empat motif mengikut urutan kejadian"],
	"鞋底暗语": ["Message beneath the shoe", "Pesanan di bawah kasut"],
	"针脚把四个秘密串成一句话：\n\n[b]继承者起意 → 账房转账 → 月澄查账 → 家宴换碗[/b]": ["The stitches join four secrets into one statement:\n\n[b]The heir plots → the clerk transfers funds → Yuecheng audits → a bowl is switched[/b]", "Jahitan menyatukan empat rahsia menjadi satu kenyataan:\n\n[b]Waris merancang → kerani memindahkan wang → Yuecheng menyemak → mangkuk ditukar[/b]"],
	"开始排列": ["Begin arranging", "Mula menyusun"],
	"未完成的珠绣鞋": ["Unfinished beaded shoe", "Kasut manik yang belum siap"],
	"鞋面缺了四段连接针脚。先读懂桌上的四枚珠样。": ["Four connecting stitches are missing. Understand the four motifs on the table first.", "Empat bahagian jahitan penghubung hilang. Fahami dahulu empat motif di atas meja."],
	"返回": ["Back", "Kembali"],
	"鞋垫下面藏着梁月澄抄下的货账编号。房门外忽然传来男人拖着鞋底走路的声音。": ["Beneath the insole is a shipping-ledger number copied by Liang Yuecheng. A man's dragging footsteps begin outside the door.", "Di bawah tapak kasut tersembunyi nombor buku penghantaran yang disalin Liang Yuecheng. Tiba-tiba kedengaran langkah seorang lelaki mengheret kasut di luar pintu."],
	"关灯，寻找藏身处": ["Turn off the light and hide", "Padamkan lampu dan bersembunyi"],
	"躲到屏风后，避开梁启文的影子": ["Hide behind the screen and evade Liang Qiwen's shadow", "Bersembunyi di belakang sekatan dan elakkan bayang Liang Qiwen"],
	"警告 · 检测到未登记访客": ["Warning · Unregistered visitor detected", "Amaran · Pelawat tidak berdaftar dikesan"],
	"折叠屏风": ["Folding screen", "Sekatan lipat"],
	"屏风后只容得下一个人。木板上有新鲜的指甲划痕。": ["There is room for only one person behind the screen. Fresh fingernail marks score the wood.", "Hanya muat seorang di belakang sekatan. Kesan kuku yang baharu mencakar kayu."],
	"退出来": ["Step out", "Keluar"],
	"回到天井，进入厨房": ["Return to the courtyard and enter the kitchen", "Kembali ke telaga udara dan masuk ke dapur"],
	"脚步远去": ["The footsteps recede", "Bunyi langkah menjauh"],
	"影子停在屏风外，低声说：“账本不是女人该看的东西。”\n\n几秒后，珠绣房的灯重新亮起。": ["The shadow stops outside the screen and whispers, “Ledgers are no business for a woman.”\n\nSeconds later, the beadwork room lights return.", "Bayang itu berhenti di luar sekatan lalu berbisik, “Buku akaun bukan urusan perempuan.”\n\nBeberapa saat kemudian, lampu bilik sulaman manik menyala semula."],
	"带走珠绣鞋": ["Take the beaded shoe", "Ambil kasut manik"],

	"厨房门上的珠绣纹样还没有完整亮起。": ["The beadwork pattern on the kitchen door is not fully lit.", "Corak manik pada pintu dapur belum menyala sepenuhnya."],
	"第三关 · 最后一顿家宴": ["Chapter 3 · The Last Family Dinner", "Bab 3 · Jamuan Keluarga Terakhir"],
	"查看灶台旁的 Ayam Pongteh 食谱": ["Read the Ayam Pongteh recipe beside the stove", "Baca resipi Ayam Pongteh di sisi dapur"],
	"娘惹厨房": ["Nyonya Kitchen", "Dapur Nyonya"],
	"炉火在无人添柴的灶里燃着。Tok Panjang 长桌摆着六只空碗，每一只都朝向一个不存在的客人。": ["Fire burns in an untended stove. Six empty bowls sit along the Tok Panjang table, each facing a guest who is no longer there.", "Api menyala di dapur tanpa dijaga. Enam mangkuk kosong tersusun di meja Tok Panjang, setiap satunya menghadap tetamu yang sudah tiada."],
	"调查食谱": ["Investigate the recipe", "Siasat resipi"],
	"再次查看发生变化的食谱": ["Read the altered recipe again", "Baca semula resipi yang berubah"],
	"豆酱、蒜头、黑酱油、椰糖、马铃薯、蓝姜。\n\n油渍下面似乎还有一层墨迹。": ["Fermented soybean paste, garlic, dark soy sauce, palm sugar, potatoes, galangal.\n\nAnother layer of ink seems to lie beneath the oil stain.", "Taucu, bawang putih, kicap pekat, gula Melaka, kentang, lengkuas.\n\nKelihatan ada satu lagi lapisan dakwat di bawah kesan minyak."],
	"放回食谱": ["Put the recipe back", "Letakkan semula resipi"],
	"按材料顺序还原 1919 年家宴席位": ["Restore the 1919 dinner seats in ingredient order", "Pulihkan tempat duduk jamuan 1919 mengikut urutan bahan"],
	"食谱变了": ["The recipe has changed", "Resipi telah berubah"],
	"豆酱 - 梁瑞廷\n蒜头 - 陈有德\n黑酱油 - 何美珠\n椰糖 - 梁月澄\n马铃薯 - 梁启文\n蓝姜 - 阿春\n\n这不是食材替换，而是一张[b]座位暗号[/b]。": ["Soybean paste - Liang Ruiting\nGarlic - Chen Youde\nDark soy sauce - He Meizhu\nPalm sugar - Liang Yuecheng\nPotato - Liang Qiwen\nGalangal - Ah Chun\n\nThese are not substitutions. They are a [b]seating code[/b].", "Taucu - Liang Ruiting\nBawang putih - Chen Youde\nKicap pekat - He Meizhu\nGula Melaka - Liang Yuecheng\nKentang - Liang Qiwen\nLengkuas - Ah Chun\n\nIni bukan penggantian bahan. Ini ialah [b]kod tempat duduk[/b]."],
	"开始摆放碗筷": ["Arrange the bowls", "Susun mangkuk"],
	"空席": ["Empty seat", "Tempat kosong"],
	"你还不知道每只碗属于谁。": ["You do not yet know who each bowl belongs to.", "Anda belum tahu setiap mangkuk milik siapa."],
	"先找食谱": ["Find the recipe first", "Cari resipi dahulu"],
	"1919 年家宴": ["The 1919 family dinner", "Jamuan keluarga 1919"],
	"六只碗已经回到那一晚的位置。梁月澄的椅子仍然向后拉开。": ["All six bowls are back in their places from that night. Liang Yuecheng's chair remains pulled away from the table.", "Keenam-enam mangkuk kembali ke tempatnya pada malam itu. Kerusi Liang Yuecheng masih tertarik ke belakang."],
	"离开长桌": ["Leave the long table", "Tinggalkan meja panjang"],
	"碗碟错位": ["The settings are wrong", "Susunan mangkuk salah"],
	"瓷碗同时轻响了一声，刚摆好的位置全部恢复原样。": ["The porcelain bowls chime together. Every place you set returns to its original position.", "Mangkuk porselin berdenting serentak. Semua tempat yang disusun kembali seperti asal."],
	"按食谱重新摆放": ["Rearrange them from the recipe", "Susun semula mengikut resipi"],
	"油渍食谱": ["Oil-stained recipe", "Resipi bernoda minyak"],
	"回到天井，进入账房": ["Return to the courtyard and enter the office", "Kembali ke telaga udara dan masuk ke bilik akaun"],
	"最后一席": ["The final place setting", "Tempat duduk terakhir"],
	"摆到梁月澄的位置时，椅子自己向后拉开。\n\n阿春藏在油渍下的字显了出来：\n[b]“不是急病。老爷的药，最后进了大小姐的碗。”[/b]": ["When you reach Liang Yuecheng's place, the chair pulls itself back.\n\nWords Ah Chun hid beneath the oil stain appear:\n[b]“It was no sudden illness. The master's medicine ended up in the young mistress's bowl.”[/b]", "Apabila anda sampai ke tempat Liang Yuecheng, kerusinya tertarik sendiri.\n\nTulisan yang disembunyikan Ah Chun di bawah kesan minyak muncul:\n[b]“Bukan sakit mengejut. Ubat tuan akhirnya masuk ke dalam mangkuk nona muda.”[/b]"],
	"记录厨房证词": ["Record the kitchen testimony", "Catat keterangan dapur"],

	"账房门锁上浮着六只碗的轮廓。家宴还没有复原。": ["Six bowl-shaped marks float across the office lock. The family dinner is not restored.", "Enam bentuk mangkuk timbul pada kunci bilik akaun. Jamuan keluarga belum dipulihkan."],
	"第四关 · 橡胶园的账册": ["Chapter 4 · The Rubber Estate Ledgers", "Bab 4 · Buku Akaun Ladang Getah"],
	"比对家账、货账与药房账": ["Compare the household, shipping and pharmacy ledgers", "Bandingkan buku rumah, penghantaran dan farmasi"],
	"梁宅账房": ["Leong House Office", "Bilik Akaun Rumah Leong"],
	"三本账摊在桌上。窗外没有雨，但屋顶仍传来雨点声。算盘珠停在一个即将组成的年份上。": ["Three ledgers lie open on the desk. There is no rain outside, yet drops still strike the roof. The abacus beads pause on the edge of a year.", "Tiga buku akaun terbuka di atas meja. Tiada hujan di luar, namun titisan masih kedengaran di bumbung. Manik sempoa berhenti hampir membentuk satu tahun."],
	"开始核账": ["Begin the audit", "Mula menyemak akaun"],
	"家账：梁瑞廷准备把部分橡胶园收益交给梁月澄管理，用于保住祖宅并补发工钱。": ["Household ledger: Liang Ruiting planned to place part of the rubber estate income under Liang Yuecheng's management to preserve the house and repay workers.", "Buku rumah: Liang Ruiting merancang menyerahkan sebahagian hasil ladang getah kepada Liang Yuecheng untuk menjaga rumah pusaka dan membayar semula gaji pekerja."],
	"货账：陈有德把三批橡胶写成损耗，款项却进入梁启文控制的空壳商号。": ["Shipping ledger: Chen Youde recorded three rubber shipments as losses, while the money entered a shell company controlled by Liang Qiwen.", "Buku penghantaran: Chen Youde mencatat tiga penghantaran getah sebagai kerugian, tetapi wang masuk ke syarikat kosong yang dikawal Liang Qiwen."],
	"药房账：家宴当日下午，梁启文签收了一份本应给梁瑞廷的镇静药。": ["Pharmacy ledger: on the afternoon of the dinner, Liang Qiwen signed for a sedative intended for Liang Ruiting.", "Buku farmasi: pada petang jamuan, Liang Qiwen menerima ubat penenang yang sepatutnya diberikan kepada Liang Ruiting."],
	"账册比对": ["Ledger comparison", "Perbandingan buku akaun"],
	"记录差异": ["Record the discrepancy", "Catat perbezaan"],
	"查看自动拨动的算盘": ["Inspect the moving abacus", "Periksa sempoa yang bergerak sendiri"],
	"三账交叉验证": ["Cross-check complete", "Semakan silang selesai"],
	"遗嘱、挪账与药物在同一场家宴交汇。梁月澄不是意外病逝，她是在揭穿账目后被灭口。": ["The will, stolen funds and medicine converge at one family dinner. Liang Yuecheng did not die from an illness. She was silenced after exposing the accounts.", "Wasiat, wang yang dialihkan dan ubat bertemu pada satu jamuan keluarga. Liang Yuecheng bukan mati kerana sakit. Dia dibunuh selepas membongkar akaun."],
	"听见算盘声": ["Listen to the abacus", "Dengar bunyi sempoa"],
	"算盘": ["Abacus", "Sempoa"],
	"珠子拨了几下又停住。还缺账册之间的对应关系。": ["The beads move, then stop. The links between the ledgers are still incomplete.", "Manik bergerak lalu berhenti. Hubungan antara buku akaun masih belum lengkap."],
	"继续核账": ["Continue auditing", "Teruskan semakan"],
	"药房账": ["Pharmacy ledger", "Buku farmasi"],
	"橡胶货运单": ["Rubber shipping manifest", "Manifes penghantaran getah"],
	"带着五件证据进入祖先厅": ["Take the five evidence items to the ancestor hall", "Bawa lima bahan bukti ke dewan nenek moyang"],
	"算盘无人触碰，却一遍遍拨出同一个数字：\n\n[b]1 · 9 · 1 · 9[/b]\n\n最后一颗珠子落下时，祖先厅的门锁响了。": ["Untouched, the abacus forms the same number again and again:\n\n[b]1 · 9 · 1 · 9[/b]\n\nWhen the final bead falls, the ancestor hall lock clicks.", "Tanpa disentuh, sempoa membentuk nombor yang sama berulang kali:\n\n[b]1 · 9 · 1 · 9[/b]\n\nApabila manik terakhir jatuh, kunci dewan nenek moyang berbunyi."],
	"收好账册证据": ["Take the ledger evidence", "Simpan bukti buku akaun"],

	"祖先厅拒绝打开。供桌前还缺能证明梁月澄死因的账册。": ["The ancestor hall refuses to open. The ledgers proving Liang Yuecheng's death are still missing.", "Dewan nenek moyang enggan terbuka. Buku akaun yang membuktikan punca kematian Liang Yuecheng masih tiada."],
	"第五关 · 最后的展签": ["Chapter 5 · The Last Label", "Bab 5 · Label Terakhir"],
	"把五件证据放进中央展柜": ["Place five evidence items in the central display case", "Letakkan lima bahan bukti di dalam kotak pameran tengah"],
	"祖先厅": ["Ancestor Hall", "Dewan Nenek Moyang"],
	"祖先牌位在烛光中排成两列。中央展柜是空的，原本属于梁月澄的位置只有一枚没有文字的铜钉。": ["Ancestral tablets stand in two candlelit rows. The central display case is empty. Where Liang Yuecheng's record should be, there is only an unmarked brass pin.", "Papan nama nenek moyang tersusun dalam dua baris cahaya lilin. Kotak pameran tengah kosong. Di tempat rekod Liang Yuecheng sepatutnya berada, hanya ada paku tembaga tanpa tulisan."],
	"走向展柜": ["Approach the display case", "Hampiri kotak pameran"],
	"离开展柜": ["Leave the display case", "Tinggalkan kotak pameran"],
	"展柜要求每一件陈列物都能对应一个档案编号。": ["The display case requires an archive number for every object.", "Kotak pameran memerlukan nombor arkib bagi setiap objek."],
	"梁月澄临时档案": ["Liang Yuecheng temporary file", "Fail sementara Liang Yuecheng"],
	"使用供桌前的档案终端生成最后展签": ["Use the archive terminal to generate the final label", "Gunakan terminal arkib untuk menjana label terakhir"],
	"证据链完整": ["Evidence chain complete", "Rantaian bukti lengkap"],
	"珠绣鞋、食谱、药房账、货运单与刮坏照片互相印证。空白铜钉上浮出了梁月澄的名字。": ["The beaded shoe, recipe, pharmacy ledger, shipping manifest and defaced photograph corroborate one another. Liang Yuecheng's name appears on the blank brass pin.", "Kasut manik, resipi, buku farmasi, manifes penghantaran dan foto yang dicakar saling mengesahkan. Nama Liang Yuecheng muncul pada paku tembaga kosong."],
	"前往档案终端": ["Go to the archive terminal", "Pergi ke terminal arkib"],
	"档案系统": ["Archive System", "Sistem Arkib"],
	"证据链不完整。系统可以生成一段适合游客阅读的说明，但无法确认真实死因。": ["The evidence chain is incomplete. The system can produce a visitor-friendly story, but it cannot confirm the true cause of death.", "Rantaian bukti tidak lengkap. Sistem boleh menghasilkan cerita mesra pelawat, tetapi tidak dapat mengesahkan punca kematian sebenar."],
	"返回展柜": ["Return to the display case", "Kembali ke kotak pameran"],
	"最后的展签": ["The Last Label", "Label Terakhir"],
	"梁月澄\n1901-1919\n梁宅账册保管人\n被家族记录抹去者\n\n档案系统询问：要如何发布这份记录？": ["Liang Yuecheng\n1901-1919\nKeeper of the Leong House ledgers\nErased from the family record\n\nThe archive system asks: how should this record be published?", "Liang Yuecheng\n1901-1919\nPenjaga buku akaun Rumah Leong\nDipadam daripada rekod keluarga\n\nSistem arkib bertanya: bagaimana rekod ini harus diterbitkan?"],
	"按证据编号发布真相": ["Publish the truth with evidence numbers", "Terbitkan kebenaran dengan nombor bukti"],
	"改写成适合游客的家族传说": ["Rewrite it as a visitor-friendly family legend", "Tulis semula sebagai legenda keluarga untuk pelawat"],
	"烧毁账册与全部证据": ["Burn the ledgers and all evidence", "Bakar buku akaun dan semua bukti"],
	"真相结局": ["Truth Ending", "Pengakhiran Kebenaran"],
	"漂亮谎言结局": ["Beautiful Lie Ending", "Pengakhiran Dusta Indah"],
	"烧毁账册结局": ["Burned Ledger Ending", "Pengakhiran Buku Akaun Terbakar"],
	"系统逐条列出照片、鞋面针脚、家宴席位、药房签收与橡胶货账。梁宅恢复白天，梁月澄的名字重新出现在族谱与展柜中。\n\n许安宁走出门时，街上的游客都回来了。只有导览 App 多出一条由梁月澄署名的感谢记录。": ["The system lists the photograph, shoe stitches, dinner seats, pharmacy receipt and rubber accounts with evidence numbers. Daylight returns to Leong House, and Liang Yuecheng's name reappears in the genealogy and display case.\n\nWhen Xu Anning steps outside, the tourists have returned. Only the guide app has changed: it now holds a note of thanks signed by Liang Yuecheng.", "Sistem menyenaraikan foto, jahitan kasut, tempat duduk jamuan, penerimaan farmasi dan akaun getah bersama nombor bukti. Siang kembali ke Rumah Leong, dan nama Liang Yuecheng muncul semula dalam salasilah serta kotak pameran.\n\nApabila Xu Anning melangkah keluar, semua pelawat telah kembali. Hanya aplikasi panduan berubah: terdapat catatan terima kasih yang ditandatangani Liang Yuecheng."],
	"许安宁要求系统把事件改成一段温柔的家族传说：大小姐远行，祖宅等她归来。门因此打开。\n\n第二天，梁月澄的展柜仍是空的。旁边新添了一张许安宁站在前厅里的照片。": ["Xu Anning asks the system to soften the case into a family legend: the young mistress travelled far away, and the ancestral house waits for her return. The door opens.\n\nThe next day, Liang Yuecheng's display remains empty. Beside it is a new photograph of Xu Anning standing in the front hall.", "Xu Anning meminta sistem melembutkan kes menjadi legenda keluarga: nona muda pergi jauh, dan rumah pusaka menunggu kepulangannya. Pintu terbuka.\n\nKeesokan harinya, pameran Liang Yuecheng masih kosong. Di sebelahnya terdapat foto baharu Xu Anning berdiri di dewan hadapan."],
	"火焰吞掉账册，梁宅所有声音在一瞬间停止。鬼影消失了一夜，家族也再没有可以被证明的罪。\n\n下一场雨开始时，导览 App 又对另一名游客说：‘第七位游客，请回到你的展柜。’": ["Fire consumes the ledgers, and every sound in Leong House stops at once. The apparitions vanish for one night, and the family's crime can no longer be proven.\n\nWhen the next rain begins, the guide app tells another visitor: 'Seventh visitor, please return to your display case.'", "Api menelan buku akaun, dan semua bunyi di Rumah Leong terhenti serta-merta. Jelmaan hilang untuk satu malam, dan jenayah keluarga itu tidak lagi dapat dibuktikan.\n\nApabila hujan seterusnya bermula, aplikasi panduan berkata kepada pelawat lain: 'Pelawat ketujuh, sila kembali ke kotak pameran anda.'"],
	"终章": ["Finale", "Penamat"],
	"第一章完": ["END OF CHAPTER ONE", "TAMAT BAB SATU"],
	"进入祖先厅": ["Enter the ancestor hall", "Masuk ke dewan nenek moyang"],
	"进入账房": ["Enter the office", "Masuk ke bilik akaun"],
	"进入厨房": ["Enter the kitchen", "Masuk ke dapur"],
	"解开珠绣房的图案": ["Solve the beadwork motifs", "Selesaikan motif sulaman manik"],
	"影子抓住了你": ["The shadow caught you", "Bayang menangkap anda"],
	"画面像旧胶片一样跳回珠绣房门口。脚步声又从头开始。": ["The image jumps like old film, returning you to the beadwork-room door. The footsteps begin again.", "Imej melompat seperti filem lama dan mengembalikan anda ke pintu bilik sulaman manik. Bunyi langkah bermula semula."],
	"重新关灯": ["Turn out the light again", "Padamkan lampu sekali lagi"],
	"门还没有承认你": ["The door does not recognise you", "Pintu belum mengenali anda"],
	"退开": ["Step back", "Berundur"],

	"进入梁宅": ["Enter Leong House", "Masuk ke Rumah Leong"],
	"查看梁氏家族合照": ["Examine the Leong family photograph", "Periksa foto keluarga Leong"],
	"扫描青花盖罐展签": ["Scan the blue-and-white jar label", "Imbas label balang biru-putih"],
	"扫描黑木太师椅展签": ["Scan the blackwood chair label", "Imbas label kerusi kayu hitam"],
	"扫描停在 19:19 的座钟": ["Scan the clock stopped at 19:19", "Imbas jam yang terhenti pada 19:19"],
	"扫描新嘉坡来信": ["Scan the letter from Singapore", "Imbas surat dari Singapura"],
	"走进天井": ["Enter the courtyard", "Masuk ke telaga udara"],
	"进入珠绣房": ["Enter the beadwork room", "Masuk ke bilik sulaman manik"],
	"进入娘惹厨房": ["Enter the Nyonya kitchen", "Masuk ke dapur Nyonya"],
	"查看凤凰珠样": ["Examine the phoenix motif", "Periksa motif feniks"],
	"查看牡丹珠样": ["Examine the peony motif", "Periksa motif peoni"],
	"查看蝴蝶珠样": ["Examine the butterfly motif", "Periksa motif rama-rama"],
	"查看石榴珠样": ["Examine the pomegranate motif", "Periksa motif delima"],
	"检查未完成的珠绣鞋": ["Inspect the unfinished beaded shoe", "Periksa kasut manik yang belum siap"],
	"躲到屏风后": ["Hide behind the folding screen", "Bersembunyi di belakang sekatan"],
	"回到天井": ["Return to the courtyard", "Kembali ke telaga udara"],
	"摆放这一席的碗筷": ["Set this place at the table", "Susun mangkuk di tempat ini"],
	"阅读 Ayam Pongteh 食谱": ["Read the Ayam Pongteh recipe", "Baca resipi Ayam Pongteh"],
	"比对梁宅家账": ["Compare the household ledger", "Bandingkan buku akaun rumah"],
	"比对橡胶货账": ["Compare the rubber shipping ledger", "Bandingkan buku penghantaran getah"],
	"比对药房账": ["Compare the pharmacy ledger", "Bandingkan buku farmasi"],
	"把证据放入最后展柜": ["Place evidence in the final display case", "Letakkan bukti dalam kotak pameran terakhir"],
	"生成梁月澄的最后展签": ["Generate Liang Yuecheng's final label", "Jana label terakhir Liang Yuecheng"],
}


static func text(source: String, language: String) -> String:
	if language == "zh" or not SUPPORTED.has(language):
		return source
	var entry: Variant = STRINGS.get(source)
	if entry is Array:
		return str(entry[0 if language == "en" else 1])
	return _dynamic_text(source, language)


static func _dynamic_text(source: String, language: String) -> String:
	var english := language == "en"
	var ending_marker := "\n\n[b]THE LAST LABEL · 第一章完[/b]"
	if source.ends_with(ending_marker):
		var ending_body := source.trim_suffix(ending_marker)
		return text(ending_body, language) + "\n\n[b]THE LAST LABEL · " + text("第一章完", language) + "[/b]"
	var case_suffix := "\n\n展柜要求每一件陈列物都能对应一个档案编号。"
	if source.begins_with("证据 ") and source.ends_with(case_suffix):
		var count_text := source.trim_prefix("证据 ").trim_suffix(case_suffix)
		return ("Evidence " if english else "Bukti ") + count_text + "\n\n" + text("展柜要求每一件陈列物都能对应一个档案编号。", language)
	if source.begins_with("继续扫描前厅展品（"):
		var progress := source.trim_prefix("继续扫描前厅展品（").trim_suffix("）")
		return ("Continue scanning front hall exhibits (" if english else "Terus imbas bahan pameran dewan (") + progress + ")"
	if source.begins_with("已放置 · "):
		return ("Placed · " if english else "Diletakkan · ") + text(source.trim_prefix("已放置 · "), language)
	if source.begins_with("放置 · "):
		return ("Place · " if english else "Letak · ") + text(source.trim_prefix("放置 · "), language)
	var prefixes := {
		"前厅任务 · 已扫描 ": ["Front hall task · Scanned ", "Tugasan dewan · Diimbas "],
		"珠样顺序 · ": ["Motif sequence · ", "Urutan motif · "],
		"家宴席位 · ": ["Dinner seats · ", "Tempat jamuan · "],
		"证据已登记 · ": ["Evidence registered · ", "Bukti didaftarkan · "],
		"档案证据  ": ["ARCHIVE EVIDENCE  ", "BUKTI ARKIB  "],
	}
	for prefix in prefixes:
		if source.begins_with(prefix):
			var translated: Array = prefixes[prefix]
			return str(translated[0 if english else 1]) + source.trim_prefix(prefix)
	return source
