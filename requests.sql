
-- —амое часто встречающеес€ медиа во всех каналах и его тип (при прочих равных - наибольшее по размеру)

SELECT chl_msg.media_id AS media_id, COUNT(media_id) as total, m_t.type, m.name, m.size FROM channels_messages AS chl_msg
  INNER JOIN media as m
    ON m.id = chl_msg.media_id
  INNER JOIN media_types as m_t
    ON m.media_type_id = m_t.id
GROUP BY media_id
ORDER BY total DESC, size DESC
LIMIT 1;

-- —писок всех групп с количеством пользователей (ќтсортирован по убыванию кол-ва юзеров)

SELECT gr.id AS group_id, COUNT(gr.id) AS total_users, gr.link FROM `groups` AS gr
  INNER JOIN groups_users AS gr_us
    ON gr.id = gr_us.group_id
  GROUP BY gr.id
  ORDER BY total_users DESC;

-- топ 10 групп/каналов по кол-ву сообщений (ѕо убыванию кол-ва сообщений)

SELECT type, entity_id, COUNT(entity_id) as total_messages FROM  (

  SELECT "group" AS type, gr.id AS entity_id FROM `groups` AS gr
    INNER JOIN groups_and_chats_messages AS gr_msg
      ON gr.id = gr_msg.from_group_id
  
  UNION ALL
  
  SELECT "channel" AS type, ch.id AS entity_id  FROM channels AS ch
    INNER JOIN channels_messages AS ch_msg
      ON ch.id = ch_msg.from_channel_id
  ) AS agg

GROUP BY entity_id, type
ORDER BY total_messages DESC
LIMIT 10;

-- топ 10 самых активных пользователей (больше всего сообщений в чатах, группах и каналах)

SELECT user_id, username, COUNT(user_id) AS total_messages FROM (

  SELECT us.id AS user_id, us.username AS username FROM users AS us
    INNER JOIN groups_and_chats_messages AS gr_ch_msg
      ON us.id = gr_ch_msg.from_user_id
  
  UNION ALL
  
  SELECT us.id AS user_id, us.username AS username FROM users AS us
    INNER JOIN channels_messages AS chl_msg
      ON us.id = chl_msg.from_auther_id
  ) AS agg

GROUP BY user_id, username
ORDER BY total_messages DESC
LIMIT 10;