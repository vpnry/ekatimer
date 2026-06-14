import json

with open('assets/translations/translations.json', 'r') as f:
    data = json.load(f)

data['ja']['meditation.tapToWake'] = '画面が暗くなりました。\n端末の設定に従ってオフになります'
data['km']['meditation.tapToWake'] = 'អេក្រង់ឥឡូវស្រអាប់\nបន្ទាប់មកនឹងបិទតាមការកំណត់ឧបករណ៍'
data['ru']['meditation.tapToWake'] = 'Экран затемнен\nи погаснет согласно настройкам устройства'
data['lo']['meditation.tapToWake'] = 'ໜ້າຈໍມືດລົງແລ້ວ,\nແລະຈະປິດຕາມການຕັ້ງຄ່າອຸປະກອນ'

with open('assets/translations/translations.json', 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Done")
