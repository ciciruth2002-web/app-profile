<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Faq;
use App\Models\Menu;
use App\Models\MenuItem;
use App\Models\Page;
use App\Models\Post;
use App\Models\Question;
use App\Models\QuestionAnswer;
use App\Models\QuestionTopic;
use App\Models\Setting;
use App\Models\Slide;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Admin Users
        User::query()->update(['role' => 'admin']);

        $admin = User::firstOrCreate(
            ['email' => 'admin@admin.com'],
            [
                'name' => 'Administrator',
                'password' => Hash::make('password'),
                'role' => 'admin',
            ]
        );

        // 2. Settings
        $settings = [
            ['group' => 'general', 'key' => 'site_name', 'value' => 'Dinas Komunikasi dan Informatika', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_tagline', 'value' => 'Mewujudkan Pelayanan Publik yang Terbuka & Digital', 'type' => 'text'],
            ['group' => 'general', 'key' => 'site_description', 'value' => 'Portal resmi profil instansi pemerintah daerah dan sarana komunikasi interaktif masyarakat.', 'type' => 'textarea'],
            ['group' => 'contact', 'key' => 'contact_email', 'value' => 'kontak@instansi.go.id', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_phone', 'value' => '(021) 12345678', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'contact_whatsapp', 'value' => '+6281234567890', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'address', 'value' => 'Jl. Merdeka No. 45, Kompleks Perkantoran Pemerintah Kota', 'type' => 'textarea'],
            ['group' => 'social', 'key' => 'social_instagram', 'value' => 'https://instagram.com/instansigoid', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_facebook', 'value' => 'https://facebook.com/instansigoid', 'type' => 'text'],
            ['group' => 'social', 'key' => 'social_youtube', 'value' => 'https://youtube.com/@instansigoid', 'type' => 'text'],
        ];

        foreach ($settings as $setting) {
            Setting::updateOrCreate(['key' => $setting['key']], $setting);
        }

        // 3. Categories
        $categoriesData = [
            ['name' => 'Berita Terkini', 'slug' => 'berita-terkini', 'description' => 'Kumpulan berita resmi seputar kegiatan instansi.', 'icon' => 'newspaper'],
            ['name' => 'Pengumuman Resmi', 'slug' => 'pengumuman-resmi', 'description' => 'Informasi penting dan edaran untuk publik.', 'icon' => 'megaphone'],
            ['name' => 'Artikel & Edukasi', 'slug' => 'artikel-edukasi', 'description' => 'Artikel informatif dan literasi digital.', 'icon' => 'academic-cap'],
            ['name' => 'Agenda Kegiatan', 'slug' => 'agenda-kegiatan', 'description' => 'Jadwal dan rincian kegiatan kedinasan.', 'icon' => 'calendar'],
        ];

        $categories = [];
        foreach ($categoriesData as $idx => $cat) {
            $categories[$cat['slug']] = Category::updateOrCreate(
                ['slug' => $cat['slug']],
                array_merge($cat, ['sort_order' => $idx + 1, 'is_active' => true])
            );
        }

        // 4. Sample Posts
        $postsData = [
            [
                'title' => 'Peluncuran Aplikasi Mobile Layanan Masyarakat',
                'summary' => 'Instansi meluncurkan aplikasi berbasis mobile untuk mempermudah masyarakat mengakses informasi dan menyampaikan pertanyaan.',
                'content' => '<p>Pemerintah instansi secara resmi merilis aplikasi portal profil dan pusat bantuan publik. Melalui inovasi ini, masyarakat dapat mengajukan pertanyaan, memantau pengumuman, serta mengakses layanan secara cepat tanpa harus datang langsung ke kantor.</p><p>Kepala Dinas menyampaikan bahwa transformasi digital ini adalah bagian dari komitmen pelayanan prima dan akuntabilitas publik.</p>',
                'category_id' => $categories['berita-terkini']->id,
                'is_featured' => true,
                'status' => 'published',
                'published_at' => now()->subDays(2),
            ],
            [
                'title' => 'Pengumuman Jadwal Pelayanan Selama Hari Libur Nasional',
                'summary' => 'Jadwal operasional pelayanan kantor tatap muka dan informasi layanan online terintegrasi.',
                'content' => '<p>Diberitahukan kepada seluruh warga masyarakat bahwa pelayanan tatap muka akan libur dan dibuka kembali pada hari kerja berikutnya. Layanan digital dan pengajuan pertanyaan online tetap dapat diakses 24 jam melalui aplikasi.</p>',
                'category_id' => $categories['pengumuman-resmi']->id,
                'is_featured' => false,
                'status' => 'published',
                'published_at' => now()->subDay(),
            ],
            [
                'title' => 'Tips Keamanan Informasi Pribadi di Era Digital',
                'summary' => 'Langkah-langkah praktis menjaga kerahasiaan data dan menghindari kejahatan siber.',
                'content' => '<p>Keamanan informasi merupakan tanggung jawab bersama. Gunakan kata sandi yang kuat, aktifkan verifikasi 2 langkah, dan jangan pernah membagikan kode OTP kepada siapapun.</p>',
                'category_id' => $categories['artikel-edukasi']->id,
                'is_featured' => true,
                'status' => 'published',
                'published_at' => now(),
            ],
        ];

        foreach ($postsData as $post) {
            Post::updateOrCreate(
                ['slug' => Str::slug($post['title'])],
                array_merge($post, [
                    'slug' => Str::slug($post['title']),
                    'user_id' => $admin->id,
                    'view_count' => rand(25, 300),
                ])
            );
        }

        // 5. Static Pages
        $pagesData = [
            [
                'title' => 'Tentang Kami',
                'slug' => 'tentang-kami',
                'content' => '<p>Dinas ini bertugas menyelenggarakan urusan pemerintahan di bidang komunikasi, informatika, statistik, dan persandian untuk membantu pimpinan daerah dalam perumusan kebijakan dan pelayanan publik.</p>',
                'status' => 'published',
                'sort_order' => 1,
                'show_in_menu' => true,
            ],
            [
                'title' => 'Visi dan Misi',
                'slug' => 'visi-misi',
                'content' => '<h3>Visi:</h3><p>Terwujudnya tata kelola pemerintahan yang transparan, cerdas, dan melayani berbasis teknologi informasi.</p><h3>Misi:</h3><ul><li>Mengembangkan infrastruktur digital yang merata dan andal.</li><li>Meningkatkan kualitas pelayanan publik berbasis data dan keterbukaan.</li><li>Mendorong literasi digital masyarakat secara berkelanjutan.</li></ul>',
                'status' => 'published',
                'sort_order' => 2,
                'show_in_menu' => true,
            ],
            [
                'title' => 'Struktur Organisasi',
                'slug' => 'struktur-organisasi',
                'content' => '<p>Struktur pimpinan terdiri atas Kepala Dinas, Sekretaris, serta Kepala Bidang yang membidangi Teknologi Informasi, Komunikasi Publik, serta Statistik & Persandian.</p>',
                'status' => 'published',
                'sort_order' => 3,
                'show_in_menu' => true,
            ],
        ];

        foreach ($pagesData as $page) {
            Page::updateOrCreate(
                ['slug' => $page['slug']],
                array_merge($page, ['user_id' => $admin->id])
            );
        }

        // 6. Slides
        Slide::updateOrCreate(
            ['title' => 'Selamat Datang di Portal Profil Instansi'],
            [
                'description' => 'Akses informasi resmi, berita terkini, dan layanan tanya jawab masyarakat dalam satu genggaman.',
                'image' => 'slides/default-banner-1.jpg',
                'link_url' => '/posts',
                'sort_order' => 1,
                'is_active' => true,
            ]
        );

        Slide::updateOrCreate(
            ['title' => 'Kanal Pertanyaan dan Aspirasi Warga'],
            [
                'description' => 'Sampaikan pertanyaan dan permohonan informasi Anda secara mudah dan transparan.',
                'image' => 'slides/default-banner-2.jpg',
                'link_url' => '/questions',
                'sort_order' => 2,
                'is_active' => true,
            ]
        );

        // 7. Question Topics
        $topicsData = [
            ['name' => 'Layanan Administrasi & Surat', 'slug' => 'layanan-administrasi', 'description' => 'Pertanyaan terkait syarat perizinan, surat rekomendasi, dan pengurusan berkas.'],
            ['name' => 'Fasilitas & Teknologi Informasi', 'slug' => 'fasilitas-ti', 'description' => 'Pertanyaan mengenai wifi publik, jaringan, dan aplikasi pemerintah.'],
            ['name' => 'Pengaduan Pelayanan', 'slug' => 'pengaduan', 'description' => 'Keluhan dan masukan terhadap efektivitas pelayanan publik.'],
            ['name' => 'Informasi Umum', 'slug' => 'informasi-umum', 'description' => 'Pertanyaan seputar jam kerja, lokasi kantor, dan agenda dinas.'],
        ];

        $topics = [];
        foreach ($topicsData as $idx => $top) {
            $topics[$top['slug']] = QuestionTopic::updateOrCreate(
                ['slug' => $top['slug']],
                array_merge($top, ['sort_order' => $idx + 1, 'is_active' => true])
            );
        }

        // 8. FAQs
        $faqsData = [
            [
                'topic_id' => $topics['informasi-umum']->id,
                'question' => 'Berapa jam operasional kantor pelayanan tatap muka?',
                'answer' => '<p>Pelayanan tatap muka dibuka setiap hari Senin sampai Jumat mulai pukul 08.00 hingga 16.00 WIB, kecuali pada hari libur nasional.</p>',
                'sort_order' => 1,
            ],
            [
                'topic_id' => $topics['layanan-administrasi']->id,
                'question' => 'Bagaimana cara mengajukan permohonan informasi publik (PPID)?',
                'answer' => '<p>Permohonan dapat diajukan secara online melalui form pertanyaan di aplikasi ini dengan memilih topik Layanan Administrasi atau datang langsung membawa fotokopi identitas (KTP).</p>',
                'sort_order' => 2,
            ],
            [
                'topic_id' => $topics['fasilitas-ti']->id,
                'question' => 'Apakah fasilitas WiFi publik di taman kota gratis?',
                'answer' => '<p>Ya, seluruh titik hotspot WiFi publik pemerintah daerah dapat diakses secara gratis oleh seluruh warga tanpa dipungut biaya apapun.</p>',
                'sort_order' => 3,
            ],
        ];

        foreach ($faqsData as $faq) {
            Faq::updateOrCreate(
                ['question' => $faq['question']],
                array_merge($faq, ['is_active' => true])
            );
        }

        // 9. Sample Questions and Answers
        $q1 = Question::updateOrCreate(
            ['email' => 'budi@warga.com', 'subject' => 'Prosedur Magang / PKL untuk Mahasiswa'],
            [
                'topic_id' => $topics['layanan-administrasi']->id,
                'name' => 'Budi Santoso',
                'phone' => '081299887766',
                'body' => 'Selamat siang admin, saya mahasiswa jurusan Ilmu Komputer ingin bertanya mengenai syarat dan prosedur pengajuan magang di dinas ini untuk periode bulan depan. Terima kasih.',
                'status' => 'answered',
                'ip_address' => '127.0.0.1',
            ]
        );

        QuestionAnswer::updateOrCreate(
            ['question_id' => $q1->id],
            [
                'user_id' => $admin->id,
                'body' => 'Selamat siang Budi. Pengajuan magang dapat dilakukan dengan menyerahkan surat pengantar resmi dari kampus beserta proposal magang dan CV ke bagian Kepegawaian atau melalui email resmi kami di kontak@instansi.go.id. Batas pendaftaran paling lambat 2 minggu sebelum periode magang dimulai.',
                'status' => 'published',
                'is_published' => true,
                'answered_at' => now(),
            ]
        );

        Question::updateOrCreate(
            ['email' => 'siti@warga.com', 'subject' => 'Informasi Jadwal Sosialisasi Literasi Digital'],
            [
                'topic_id' => $topics['informasi-umum']->id,
                'name' => 'Siti Rahmawati',
                'phone' => '085712349876',
                'body' => 'Kapan dinas akan menyelenggarakan webinar / sosialisasi keamanan digital untuk pelajar SMA berikutnya?',
                'status' => 'pending',
                'ip_address' => '127.0.0.1',
            ]
        );

        // 10. Menus
        $headerMenu = Menu::updateOrCreate(
            ['name' => 'Menu Utama', 'location' => 'header'],
            ['is_active' => true]
        );

        $menuItems = [
            ['label' => 'Beranda', 'url' => '/', 'type' => 'custom', 'sort_order' => 1],
            ['label' => 'Tentang Kami', 'url' => '/page/tentang-kami', 'type' => 'page', 'sort_order' => 2],
            ['label' => 'Berita', 'url' => '/posts', 'type' => 'custom', 'sort_order' => 3],
            ['label' => 'Tanya Jawab', 'url' => '/questions', 'type' => 'custom', 'sort_order' => 4],
            ['label' => 'FAQ', 'url' => '/faqs', 'type' => 'custom', 'sort_order' => 5],
        ];

        foreach ($menuItems as $item) {
            MenuItem::updateOrCreate(
                ['menu_id' => $headerMenu->id, 'label' => $item['label']],
                array_merge($item, ['menu_id' => $headerMenu->id, 'is_active' => true])
            );
        }
    }
}
