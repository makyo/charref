# -*- coding: utf-8 -*-
# Generated by Django 1.10.3 on 2016-11-04 03:47
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='StreamItem',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('action_time', models.DateTimeField(auto_now_add=True)),
                ('action_type', models.CharField(choices=[(b'C', b'created'), (b'R', b'viewed'), (b'U', b'edited'), (b'D', b'deleted'), (b'IA', b'attached an image to'), (b'ID', b'detached an image from'), (b'MA', b'added a morph to'), (b'MD', b'removed a morph from'), (b'DA', b'added a description to'), (b'DD', b'removed a description from'), (b'LA', b'attached a character to'), (b'LD', b'detached a character from')], max_length=2)),
                ('notes', models.TextField(blank=True)),
                ('object_id', models.PositiveIntegerField()),
                ('content_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='contenttypes.ContentType')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-action_time'],
            },
        ),
    ]
