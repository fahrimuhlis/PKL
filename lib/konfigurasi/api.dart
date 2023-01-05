import 'package:Edimu/konfigurasi/KonfigurasiAplikasi.dart';

class UrlAPI {
  // static String getSPp = "http://103.82.243.66:7800/rest/accounts/48/status";

  // =================================================================
  // ============== API MARKETPLACE (CART-SYSTEM) ====================
  // =================================================================

  static String setToko = TemplateAplikasi.apiDomain + "marketplaces/setStore";
  static String getDataToko =
      TemplateAplikasi.apiDomain + "marketplaces/getStore";
  static String jualBarang14juli2021 =
      TemplateAplikasi.apiDomain + "marketplaces/addItemStore";
  static String getMarketplace14juli2021 =
      TemplateAplikasi.apiDomain + "marketplaces/getItemStore";
  static String confirmBeli14juli2021 =
      TemplateAplikasi.apiDomain + "marketplaces/postBuyWithFee";
  static String editLapakJuli2021 =
      TemplateAplikasi.apiDomain + "marketplaces/editItem";
  static String getLapakku =
      TemplateAplikasi.apiDomain + "marketplaces/lapakku";

  // =================================================================
  // ======================== Subsidi Minyak =========================
  // =================================================================

  static String subsidiMinyak = TemplateAplikasi.apiDomain + "getDataSubsidi";
  static String postBeliMinyakSubsidi =
      TemplateAplikasi.apiDomain + "postTransaksiMinyak";

  // =================================================================
  // ========================== Pay Later ============================
  // =================================================================

  static String getHistoryPaylater =
      TemplateAplikasi.apiDomain + "paylater/detail/riwayat";

  // =================================================================

  // ===== Tarik dana transfer
  static String getDataBankNasabah =
      TemplateAplikasi.apiDomain + "getdatabanknasabah";
  static String tambahBankNasabah =
      TemplateAplikasi.apiDomain + "tambahdatabanknasabah";
  static String hapusBankNasabah =
      TemplateAplikasi.apiDomain + "deletedatabanknasabah";
  static String requestTarikTransfer =
      TemplateAplikasi.apiDomain + "cashouttransfer";
  // ======

  static String login = TemplateAplikasi.apiDomain + "login";
  static String baseInfo = TemplateAplikasi.apiDomain + "base_info";
  static String topup = TemplateAplikasi.apiDomain + "topup";
  static String getContacts = TemplateAplikasi.apiDomain + "getcontacts";
  static String getTeller = TemplateAplikasi.apiDomain + "getteller";
  static String cekPin = TemplateAplikasi.apiDomain + "cekpin";
  static String editAlamat =
      TemplateAplikasi.apiDomain + "personal/post-address";

  static String transfer = TemplateAplikasi.apiDomain + "transfer";
  static String transfer16feb21 =
      TemplateAplikasi.apiDomain + "transfer16feb21";

  static String getHistory = TemplateAplikasi.apiDomain + "riwayatJanuari2022";
  static String getDetailHistory = TemplateAplikasi.apiDomain + "detailriwayat";
  static String tarikTunai = TemplateAplikasi.apiDomain + "tariktunai";
  static String ubahPassword = TemplateAplikasi.apiDomain + "ubahpassword";

  static String register = TemplateAplikasi.apiDomain + "daftar";
  static String pradaftar = TemplateAplikasi.apiDomain + "pradaftar";

  //get QRIS komunitas
  static String getQRISKomunitas = TemplateAplikasi.apiDomain + "getQRIS";

  // API untuk Merchant & QR-Code
  static String getUserById = TemplateAplikasi.apiDomain + "getuserid";
  static String confirmBelanjaMerchant =
      TemplateAplikasi.apiDomain + "konfirmasibelanjamerchant";

  static String tambahKomunitas =
      TemplateAplikasi.apiDomain + "tambahkomunitas";
  static String tambahLembaga = TemplateAplikasi.apiDomain + "tambahlembaga";

  // =================================================================
  // ======================== API BAYAR SPP  =========================
  // =================================================================

  static String getTagihan = TemplateAplikasi.apiDomain + "gettagihan";
  static String bayarSekolah = TemplateAplikasi.apiDomain + "bayarsekolah";
  static String getRiwayatPembayaranSekolah =
      TemplateAplikasi.apiDomain + "riwayatBayarSekolah";

  static String dataSekolah = TemplateAplikasi.apiDomain + "getdata";
  static String postDataSekolah = TemplateAplikasi.apiDomain + "postdata";
  static String excelMapping = TemplateAplikasi.apiDomain + "excelmapping";

  // =================================================================
  // =================================================================

  static String getLapakLokal = TemplateAplikasi.apiDomain + 'marketplace';
  static String getLapakPagination =
      TemplateAplikasi.apiDomain + 'marketplace18jan21';
  static String cariLapak = TemplateAplikasi.apiDomain + 'carilapakjuli2021';
  static String getLapakKategori =
      TemplateAplikasi.apiDomain + 'marketplaces/getitembycategory';

  static String bikinLapak = TemplateAplikasi.apiDomain + 'bikinlapak';
  static String bikinLapakJan2021 =
      TemplateAplikasi.apiDomain + 'bikinlapakjan2021';
  static String konfirmasiBeli = TemplateAplikasi.apiDomain + 'konfirmasibeli';
  static String getRiwayatMarketplace =
      TemplateAplikasi.apiDomain + 'riwayatmarketplace?page=';
  static String getRiwayatPenjualan =
      TemplateAplikasi.apiDomain + 'riwayatpenjualan?page=';

  static String urlGetGambar = TemplateAplikasi.apiDomain + "data_file/";

  // ======================================================================
  // ============================= PPOB ===================================
  // ======================================================================

  // ======================================================================
  // PULSA PREPAID

  static String getPricelistPulsa =
      TemplateAplikasi.apiDomain + "check/pricelist/pulsa";

  static String topupPulsaPrepaid =
      TemplateAplikasi.apiDomain + "topup_request";

  // LISTRIK PRABAYAR
  static String getPricePLNPrabayar =
      TemplateAplikasi.apiDomain + "check/pelanggan";

  static String beliTokenPLNPrepaid =
      TemplateAplikasi.apiDomain + "topup_requestPLN";

  static String getRiwayatTokenPLNPrepaid =
      TemplateAplikasi.apiDomain + "getRiwayatPLNPrabayar";

  // PDAM

  static String getWilayahPDAM =
      TemplateAplikasi.apiDomain + "pasca/pdam/wilayah";

  // E-SAMSAT

  static String getWilayahSamsat =
      TemplateAplikasi.apiDomain + "pasca/samsat/wilayah";

  // ====================================
  // ================  LISTRIK PASCABAYAR
  // ====================================

  static String getTagihanPascaBayar =
      TemplateAplikasi.apiDomain + "pasca/inquiryPLN";

  static String bayarTagihanPascaBayar =
      TemplateAplikasi.apiDomain + "pasca/paidPLN";

  static String getRiwayatPascaPLN =
      TemplateAplikasi.apiDomain + "pasca/getRiwayatPasca";

  // ====================================
  // ================  PEMBAYARAN SEKOLAH
  // ====================================

  static String getDataTagihanSekolahFebruari2022 =
      TemplateAplikasi.apiDomain + "sekolah/detail/tagihan";

  static String bayarTagihanSekolahFebruari2022 =
      TemplateAplikasi.apiDomain + "sekolah/bayar/tagihan";

  static String getRiwayatPembayaranSekolahFebruari2022 =
      TemplateAplikasi.apiDomain + "sekolah/riwayatbayar";
}
