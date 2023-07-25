<div dir="rtl">


الگویی برای پروژهای فلاتر بر اساس پکیج Getx

<h2>
نحوه استفاده و کاربرد
</h2>
<p style='text-align="justify"'>
این پروژه نقطه شروعی برای پروژه های فلاتری است که با بکارگیری  پکیج Getx علاوه بر مدیریت وضعیت ساده تر از امکانات و توابع توکار این پکیج نیز می توان استفاده کرد . بعضی از ویژگیهایی که لازمه هر نرم افزار موبایلی می باشد مانند تغییر زبان و قالب و همچنین منوهای آماده و کتابخانه هایی که کاربرد زیادی دارند به پروژه اضافه شده است و به صورت مداوم تغییرات به مخزن کد ارسال خواهند شد .
برای کار با بانک اطلاعاتی از sqfEntity به عنوان یک ORM استفاده شده است که امکانات توکار زیادی علاوه بر ایجاد بانک اطلاعاتی ورمزگذاری روی آن دارد .  .برای کار با آن کافیست فایل model.dart را مطابق خواست خود تغییر دهید در این فایل سه جدول به صورت نمونه ایجاد شده اند تا با نحوه تعریف جداول آشنا شوید . پس از تعریف جداول جدید و تغییرات مورد نظر خود فایل های model.g.dart , model.g.view.dart را حذف کرده و در ترمینال دستور زیر را صادر نمایید :
<br/>
<div dir="ltr">
<pre >
flutter pub run build_runner build --delete-conflicting-outputs
</pre>
</div>
این دستور  کدهای لازم برای کار با جداول را در فایل model.g.dart و ویوهای متناظر را در فایل model.g.view.dart ایجاد خواهد کرد . 
</p>
<br/>
<a href='https://github.com/jonataslaw/getx'> 
  [لینک مخزن Getx]</a>
<br/>
<a  href='https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager'> [لینک مستندات Getx ]</a>
<br/>
<a  href='https://github.com/hhtokpinar/sqfEntity'> [sqfEntity ORM ]</a>
<br/>
<br/>
<!-- <img width='300px' height='533px' src='https://github.com/master11641/Fast_learning/blob/master/images/image1.png' alt='snapshot' /> -->

</div>