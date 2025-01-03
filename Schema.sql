create table doktorlar
(
    id                 int auto_increment
        primary key,
    ad                 varchar(50)  not null,
    uzmanlik_alani     varchar(100) null,
    iletisim_bilgileri text         null
)
    collate = utf8mb4_general_ci;

create table hastalar
(
    id                 int auto_increment
        primary key,
    ad                 varchar(50)  not null,
    soyad              varchar(50)  not null,
    dogum_tarihi       date         null,
    iletisim_bilgileri text         null,
    adres              varchar(255) null
)
    collate = utf8mb4_general_ci;

create table kategoriler
(
    id       int auto_increment
        primary key,
    ad       varchar(50) not null,
    aciklama text        null,
    constraint ad
        unique (ad)
)
    collate = utf8mb4_general_ci;

create table ilaclar
(
    id                  int auto_increment
        primary key,
    ad                  varchar(50)    not null,
    barkod              varchar(50)    not null,
    kategori_id         int            null,
    fiyat               decimal(10, 2) not null,
    son_kullanma_tarihi date           not null,
    constraint barkod
        unique (barkod),
    constraint ilaclar_ibfk_1
        foreign key (kategori_id) references kategoriler (id)
)
    collate = utf8mb4_general_ci;

create table ilac_iade
(
    id           int  not null
        primary key,
    urun_id      int  null,
    iade_tarihi  date null,
    iade_miktari int  null,
    gerekce      text null,
    constraint ilac_iade_ibfk_1
        foreign key (urun_id) references ilaclar (id)
);

create index urun_id
    on ilac_iade (urun_id);

create index kategori_id
    on ilaclar (kategori_id);

create table kullanicilar
(
    id            int auto_increment
        primary key,
    kullanici_adi varchar(50)                          not null,
    sifre_hash    varchar(255)                         not null,
    rol           enum ('Admin', 'Eczacı', 'Personel') null,
    constraint kullanici_adi
        unique (kullanici_adi)
)
    collate = utf8mb4_general_ci;

create table log_kayitlari
(
    id           int auto_increment
        primary key,
    islem_turu   varchar(100)                        null,
    kullanici_id int                                 null,
    islem_tarihi timestamp default CURRENT_TIMESTAMP not null,
    constraint log_kayitlari_ibfk_1
        foreign key (kullanici_id) references kullanicilar (id)
)
    collate = utf8mb4_general_ci;

create index kullanici_id
    on log_kayitlari (kullanici_id);

create table musteriler
(
    MusteriID int          not null
        primary key,
    Isim      varchar(100) null,
    Soyisim   varchar(100) null,
    Telefon   varchar(15)  null,
    Eposta    varchar(100) null,
    Adres     varchar(255) null
);

create table personel
(
    id                 int auto_increment
        primary key,
    ad                 varchar(50)  not null,
    pozisyon           varchar(100) null,
    iletisim_bilgileri text         null
)
    collate = utf8mb4_general_ci;

create table personel_izin
(
    izin_id        int  not null
        primary key,
    personel_id    int  null,
    izin_baslangic date null,
    izin_bitis     date null,
    constraint personel_izin_ibfk_1
        foreign key (personel_id) references personel (id)
);

create index personel_id
    on personel_izin (personel_id);

create table raporlar
(
    id               int auto_increment
        primary key,
    olusturma_tarihi timestamp default CURRENT_TIMESTAMP not null,
    rapor_turu       varchar(100)                        null
)
    collate = utf8mb4_general_ci;

create table receteler
(
    id            int auto_increment
        primary key,
    hasta_id      int  not null,
    doktor_id     int  not null,
    recete_tarihi date not null,
    constraint receteler_ibfk_1
        foreign key (hasta_id) references hastalar (id),
    constraint receteler_ibfk_2
        foreign key (doktor_id) references doktorlar (id)
)
    collate = utf8mb4_general_ci;

create table fatura
(
    id           int auto_increment
        primary key,
    recete_id    int                         not null,
    toplam_tutar decimal(10, 2)              not null,
    odeme_durumu enum ('Ödendi', 'Ödenmedi') null,
    constraint fatura_ibfk_1
        foreign key (recete_id) references receteler (id)
)
    collate = utf8mb4_general_ci;

create index recete_id
    on fatura (recete_id);

create table odemeler
(
    id           int auto_increment
        primary key,
    fatura_id    int         not null,
    odeme_tarihi date        not null,
    odeme_turu   varchar(50) null,
    constraint odemeler_ibfk_1
        foreign key (fatura_id) references fatura (id)
)
    collate = utf8mb4_general_ci;

create index fatura_id
    on odemeler (fatura_id);

create table recete_detaylari
(
    recete_id         int         not null,
    ilac_id           int         not null,
    miktar            int         not null,
    kullanim_talimati varchar(50) null,
    primary key (recete_id, ilac_id),
    constraint recete_detaylari_ibfk_1
        foreign key (recete_id) references receteler (id),
    constraint recete_detaylari_ibfk_2
        foreign key (ilac_id) references ilaclar (id)
)
    collate = utf8mb4_general_ci;

create index ilac_id
    on recete_detaylari (ilac_id);

create index doktor_id
    on receteler (doktor_id);

create index hasta_id
    on receteler (hasta_id);

create table stok
(
    ilac_id              int          not null
        primary key,
    adi                  varchar(255) null,
    barkod               bigint       null,
    fiyat                int          null,
    son_kullanma_tarihi  date         null,
    kategori_id          varchar(255) null,
    mevcut_miktar        int          not null,
    kritik_stok_seviyesi int          not null,
    constraint stok_ibfk_1
        foreign key (ilac_id) references ilaclar (id)
)
    collate = utf8mb4_general_ci;

create table tedarikciler
(
    id                 int auto_increment
        primary key,
    ad                 varchar(100) not null,
    iletisim_bilgileri text         null,
    email              varchar(255) null
)
    collate = utf8mb4_general_ci;

create table siparisler
(
    id             int auto_increment
        primary key,
    tedarikci_id   int            not null,
    siparis_tarihi date           not null,
    toplam_tutar   decimal(10, 2) null,
    constraint siparisler_ibfk_1
        foreign key (tedarikci_id) references tedarikciler (id)
)
    collate = utf8mb4_general_ci;

create table siparis_detaylari
(
    siparis_id int            not null,
    ilac_id    int            not null,
    miktar     int            not null,
    fiyat      decimal(10, 2) not null,
    primary key (siparis_id, ilac_id),
    constraint siparis_detaylari_ibfk_1
        foreign key (siparis_id) references siparisler (id),
    constraint siparis_detaylari_ibfk_2
        foreign key (ilac_id) references ilaclar (id)
)
    collate = utf8mb4_general_ci;

create index ilac_id
    on siparis_detaylari (ilac_id);

create index tedarikci_id
    on siparisler (tedarikci_id);

